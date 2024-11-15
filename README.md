# padvar Stata Package

## Overview
**padvar** is a Stata package designed to standardize and concatenate variables by padding them with a specified value. This is especially useful when working with datasets that require uniform variable lengths for formatting, data processing, or export purposes.

## Installation
To install the **padvar** package, execute the following command on Stata:
```stata
net install padvar, from(https://raw.githubusercontent.com/NgChunMan/padvar/main/)
```

## Notes
- The **PADvalue** option must be a single character or a single digit. If a longer string is provided, an error message will be displayed.
- Ensure that the specified variables are of the supported types (string, byte, integer, long, float) to avoid errors.

## Syntax
```stata
padvar varlist [if], GENerate(newvar) [PADvalue(value)]
```

### Options
- **GENerate(newvar)**: Specifies the name of the new variable where the padded and concatenated result will be stored. This option is required.
- **PADvalue(value)**: Specifies the value used for padding. Defaults to "0" if not provided.

## Usage Examples
### Example 1: Basic Padding with Default Value
Pad and concatenate the variables `var1` and `var2`, storing the result in `new_var`.
```stata
padvar var1 var2, generate(new_var)
```

### Example 2: Padding with Custom Value
Use a custom padding value (e.g., "X") to pad `var1` and `var2`.
```stata
padvar var1 var2, generate(new_var) padvalue(X)
```

### Example 3: Conditional Padding
Pad `var1` and `var2` only for observations where `var3` (e.g., year) equals 2024:
```stata
padvar var1 var2 if var3 == 2024, generate(new_var)
```
In this example, `var3` could be a variable representing a year or any condition that subsets the data to be padded.

## Details
1. **Supported Variable Types**: `padvar` only processes variables of type string, byte, integer, long, and float. If a variable is not one of these types, an error will be displayed.

2. **Length Calculation**:
   - For string variables, the length of each observation's value is calculated directly.
   - For numeric variables, values are converted to strings before padding.

3. **Automatic Padding**: `padvar` automatically determines the maximum length of the values in the variable and pads shorter values to match this length.

4. **Uniform Length Check**: If all values in the specified variable are already of the same length, a message will be displayed: "All values in the variable are the same length. No padding is needed for this variable." In this case, no new variable is created.

5. **Floating-Point Handling**: For floating-point numbers, `padvar` calculates the number of decimal places and ensures uniform padding to the maximum number of decimal places across observations.

## Error Handling
- If `varlist` is empty, the program displays an error:
  ```
  varlist required
  ```
- If the `PADvalue` is not a single character, the program displays:
  ```
  Error: PADvalue must be a single character or single digit.
  ```
- If unsupported variable types are detected:
  ```
  Error: The variable `var` must be of type string, integer, float, long or byte. Found type: `var_type`.
  ```

## Testing

First, download the `padvar` zip folder and unzip it. Inside the unzipped folder, there is a subfolder named `data` which contains three datasets that will be used for testing. 

Next, open Stata and set your working directory to the `padvar` folder where the `data` subfolder is located. Then, execute the commands below to test the `padvar` command.

### Test 1: To Test String Variables

**Step-by-Step Explanation**:
1. Load the dataset `GroupA.dta` into Stata.
   ```stata
   use "data/GroupA.dta", clear
   ```

2. Pad the variable `code_arr` with the character "0" and generate a new variable `code_arr_2`.
   ```stata
   padvar code_arr, gen(code_arr_2) padvalue("0")
   ```
   This command takes the `code_arr` variable, pads its values with "0" to ensure uniform length, and stores the result in a new variable `code_arr_2`.

3. Repeat the same process for the variable `code_com`.
   ```stata
   padvar code_com, gen(code_com_2) padvalue("0")
   ```

4. Create a new variable `municipality_code` by concatenating `code_dep`, `code_com`, and `com_abs` but only for observations where `code_arr_2` equals "000".
   ```stata
   padvar code_dep code_com com_abs if code_arr_2 == "000", gen(municipality_code) padvalue("0")
   ```
   This command pads and concatenates the specified variables with the condition that `code_arr_2` must be "000".

5. Create another variable `municipality_code_2` by concatenating `code_dep`, `code_arr`, and `com_abs` without any condition.
   ```stata
   padvar code_dep code_arr com_abs, gen(municipality_code_2) padvalue("0")
   ```

6. Replace the values of `municipality_code` with `municipality_code_2` if `municipality_code` is empty and drop `municipality_code_2`. We will now have our municipality code with standardised length.
   ```stata
   replace municipality_code = municipality_code_2 if municipality_code == ""
   drop municipality_code_2
   ```
   This ensures that any empty `municipality_code` values are filled with the corresponding value from `municipality_code_2`.

### Test 2: To Test Byte, Long, Integer, and Float Variables

**Dataset**: `nhis9711.dta`
1. Load the `nhis9711.dta` dataset and keep only relevant variables.
   ```stata
   use "data/nhis9711.dta", clear
   keep serial sex weight regionbr
   ```
   This loads the dataset and retains only `serial`, `sex`, `weight`, and `regionbr` variables for testing.

2. Test padding for the byte variable `sex`.
   ```stata
   padvar sex, gen(sex_pad)
   ```
   - **Expected Output**: Stata displays: "All values in the variable sex are the same length. No padding is needed for this variable."

3. Test padding for the byte variable `sex`.
   ```stata
   padvar regionbr, gen(sex_pad) pad("00")
   ```
   - **Expected Output**: Stata displays: "Error: PADvalue must be a single character or single digit."

3. Test padding for `regionbr`, ensuring no missing values are considered.
   ```stata
   padvar regionbr if !missing(regionbr), gen(regionbr_pad) padvalue("0")
   ```
   - **Expected Output**: Successful padding of the `regionbr` variable.

4. Test padding for the `serial` variable (long type).
   ```stata
   padvar serial, gen(serial_padded) padvalue("0")
   ```
   - **Expected Output**: Successful padding of the `serial` variable.

5. Test padding for the integer variable `weight`.
   ```stata
   padvar weight, gen(weight_pad)
   ```
   - **Expected Output**: Successful padding of the `weight` variable.

**Dataset**: `gdp_growth.dta`

6. Load the `gdp_growth.dta` dataset.
   ```stata
   use "data/gdp_growth.dta", clear
   ```

7. Test padding for the float variable `year_1970`.
   ```stata
   padvar year_1970 if !missing(year_1970), gen(gdp_1970_pad)
   ```

8. Test padding for `year_1980`.
   ```stata
   padvar year_1980 if !missing(year_1980), gen(gdp_1980_pad)
   ```

9. Test padding for `year_1990`.
   ```stata
   padvar year_1990 if !missing(year_1990), gen(gdp_1990_pad)
   ```
   - **Expected Output**: Successful padding for each float variable with standardised decimal points.

## License
This project is licensed under the MIT License.
