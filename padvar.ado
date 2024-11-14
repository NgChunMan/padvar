* padvar.ado
* Purpose: Pad and concatenate variables to standardized format
* Syntax: padvar varlist [if], GENerate(str) [PADvalue(string)]
* Options:
*   - GENerate(str): Specifies the name of the new variable to store the padded concatenation.
*   - PADvalue(string): Specifies the value used for padding; defaults to "0" if not specified.

program define padvar
    syntax varlist [if], GENerate(str) [PADvalue(string)]

    // Set default padding character to "0" if not specified
    local padvalue = cond("`padvalue'" == "", "0", "`padvalue'")

    if strlen("`padvalue'") > 1 {
        display as error "Error: PADvalue must be a single character or single digit."
        error 198
    }
	
	tempvar var_length_check
	
    foreach var in `varlist' {
        local var_type = "`: type `var''"
		local is_string = 0

        if substr("`var_type'", 1, 3) == "str" {
            gen `var_length_check' = length(`var')
			local is_string = 1
        }
		else {
            gen `var_length_check' = length(string(`var'))
        }

        // Check if all lengths are the same
        summarize `var_length_check', meanonly
        local ref_length = r(min)

        quietly count if `var_length_check' != `ref_length'
        if r(N) == 0 {
            display as text "All values in the variable `var' are the same length. No padding is needed for this variable."
            drop `var_length_check'
            exit 0
        }
        drop `var_length_check'
		
		if `is_string' != 1 & !inlist("`var_type'", "int", "float", "long", "byte") {
            display as error "Error: The variable `var' must be of type string, integer, float, long or byte. Found type: `var_type'."
            error 198
        }
    }	

    local id_var = "`generate'"
    tempvar var_length var_padded
	
	quietly {

		gen strL `id_var' = ""

		foreach var in `varlist' {
			local var_type = "`: type `var''"
			local is_string = 0

			// Create a temporary variable for the lengths of each observation's value
			if substr("`var_type'", 1, 3) == "str" {
				gen `var_length' = length(`var')
				local is_string = 1
			}
			else {
				gen `var_length' = length(string(`var'))
			}

			tempvar decimal_position decimal_count current_number_of_decimal number_to_pad total_length

			// Initialize padding logic based on variable type
			if "`var_type'" == "float" {
				gen `decimal_position' = strpos(string(`var'), ".")
				
				count if `decimal_position' == 0
				local all_no_decimal = r(N) == _N
				
				gen `current_number_of_decimal' = `var_length' - `decimal_position'
				summarize `current_number_of_decimal' `if'
				gen `decimal_count' = r(max)
				
				if `all_no_decimal' {
					gen `number_to_pad' = 2
				}
				else {
					gen `number_to_pad' = `decimal_count' - `current_number_of_decimal' if `decimal_position' != 0
					replace `number_to_pad' = `decimal_count' if `decimal_position' == 0
				}
				gen `total_length' = r(max) + `decimal_position'
				summarize `total_length' `if'
				local maxlen = r(max)
				
				drop `decimal_count' `current_number_of_decimal' `total_length'
			}
			else {
				summarize `var_length' `if'
				local maxlen = cond(r(max) != ., r(max), 0)
			}

			if `is_string' == 1 {
				gen str`maxlen' `var_padded' = substr("`padvalue'" * `maxlen' + `var', -`maxlen', .) `if'
			}
			else if "`var_type'" == "float" {
				gen str`maxlen' `var_padded' = ""
				local obs = _N
				forval i = 1/`obs' {
					local position = `decimal_position'[`i']
					if `position' == 0 {
						replace `var_padded' = string(`var') + "." + "`padvalue'" * `number_to_pad' if _n == `i'
					}
					else {
						replace `var_padded' = string(`var') + "`padvalue'" * `number_to_pad' if _n == `i'
					}
				}
				drop `decimal_position' `number_to_pad'
			}
			else {
				gen str`maxlen' `var_padded' = substr("`padvalue'" * `maxlen' + string(`var'), -`maxlen', .) `if'
			}

			// Append the padded version of the current variable to the identifier variable
			replace `id_var' = `id_var' + `var_padded' `if'
			
			drop `var_length' `var_padded'
		}
	}
end
