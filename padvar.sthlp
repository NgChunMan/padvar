{smcl}
{* *! version 1.0  13nov2024}{...}
{viewerjumpto "Syntax" "padvar##syntax"}{...}
{viewerjumpto "Description" "padvar##description"}{...}
{viewerjumpto "Options" "padvar##options"}{...}
{viewerjumpto "Details" "padvar##details"}{...}
{viewerjumpto "Examples" "padvar##examples"}{...}
{viewerjumpto "Authors" "padvar##authors"}{...}

{p2col:{opt padvar}}Pad and Concatenate Variables to Standardized Format{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmdab: padvar} {varlist} [{cmdab:if} {it:exp}] {cmd:,} {opth gen:erate(newvar)} [{opt pad:value}{cmd:(}{it:value}{cmd:)}]

{marker description}{...}
{title:Description}

{pstd}
{opt padvar} takes in either a single variable or a varlist, standardizes the length of each specified variable by padding them with a chosen character or digit, and concatenates the padded results to create a new variable, {newvar}.
{opt padvar} supports only string, byte, integer, long and float data types, ensuring that each input variable has a consistent length and combines them seamlessly into one output variable.
{p_end}

{pstd}
The padded values are stored in a new variable, specified using the {opth generate(newvar)} option.
{p_end}

{marker options}{...}
{title:Options}

{phang}
{opth gen:erate(newvar)} is required and specifies the name of the variable to be created.
{p_end}

{phang}
{opt pad:value(value)} specifies the value used to pad the variable. This value must be a single character or single digit. If not specified, the default is "0".
{p_end}

{marker details}{...}
{title:Details}

{pstd}
1. {bf:padvar} only processes variables of type string, byte, integer, long and float. If a variable is not one of these types, an error will be displayed.{p_end}

{pstd}
2. If the variable is a string, the length of each observation's value is calculated directly. If the variable is numeric, each value is converted to a string before padding.{p_end}

{pstd}
3. {bf:padvar} automatically determines the maximum length of values in the variable and pads shorter values to match this length.{p_end}

{pstd}
4. If all values in the specified variable are already of the same length, a message will be displayed: "All values in the variable are the same length. No padding is needed for this variable." In this case, no new variable is created.{p_end}

{pstd}
5. For floating-point numbers, {bf:padvar} calculates the number of decimal places and ensures uniform padding to the maximum number of decimal places across observations.{p_end}

{marker examples}{...}
{title:Examples}

{hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}{p_end}

{pstd}Create a new variable {cmd:name_pad} with default padding of "0"{p_end}
{phang2}{cmd:. padvar make, generate(name_pad)}{p_end}

{pstd}Create a new variable {cmd:price_pad} padding {cmd:price} if {cmd:mpg} is more than 10, using "a"{p_end}
{phang2}{cmd:. padvar price if mpg > 10, generate(price_pad) padvalue("a")}{p_end}

{hline}

{marker authors}{...}
{title:Authors}

{phang}
James Sharon Susan, Ng Chun Man, N Mufiz Ahmed, and Tao Zilin{p_end}
