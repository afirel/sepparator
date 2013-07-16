sepparator - separating value from commata
===========================================

Simple CSV pocket-knife-tool.

Features:
---------
* convert CSV to Excel format and detect datatypes

Tries to detect appropriate datatypes and therefore you might get rid of the CSV-like question "what's decimal separator?".


```
Usage:
  sepp convert CSV XLS 

Options:
  -s, [--col-sep=\t]  # CSV column separator, defaults to tab-separated values
  -f, [--force]       # overwrite existing files

Description:
  `sepp convert` converts a CSV file to a xlsx file.

  Parameters:

  CSV - path to a CSV file (required)

  XLS - destination path for excel file (optional)
   Use --force to overwrite existing files.
   If XLS is ommited, sepp will create the excel file alongside the csv using the .xlsx extension.

  Options:

  --col_sep - CSV column separation character(s)

  --force - overwrite destination files if necessary
```
