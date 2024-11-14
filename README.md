# padvar Stata Package

## Overview
**padvar** is a Stata package designed to standardize and concatenate variables by padding them with a specified value. This is especially useful when working with datasets that require uniform variable lengths for formatting, data processing, or export purposes.

## Installation
To install the **padvar** package, execute the following command on Stata:
```stata
net install padvar, from(https://your-repo-link)
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

## License
This project is licensed under the MIT License.
