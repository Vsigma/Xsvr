QrCodes
=======

Powershell Module to create QRCodes (with some support for other formats).

Use Out-BarcodeImage to generate an image file containing a barcode.  ConvertTo-QRCode can be used to convert a string to a QRCode and then pipe to Format-QRCode to display the code on screen.

There are also functions to search upcdatabase.com (Find-UPC) and to create a VCard string (New-VCard).  You will need to provide your own API key to use the Find-UPC command.
