# Name of the output file
extern "fsharpc" [
	--out:					# Name of the output file
	--target:exe					# Build a console executable
	--target:winexe					# Build a Windows executable
	--target:library					# Build a library
	--target:module					# Build a module that can be added to another assembly
	--delaysign+					# Delay-sign the assembly using only the public portion of the strong name key
	--delaysign-					# Disable --delaysign
	--doc:					# Write the xmldoc of the assembly to the given file
	--keyfile:					# Specify a strong name key file
	--keycontainer:					# Specify a strong name key container
	--platform:x86					# Limit the platform to x86
	--platform:Itanium					# Limit the platform to Itanium
	--platform:x64					# Limit the platform to x64
	--platform:anycpu32bitpreferred					# Limit the platform to anycpu32bitpreferred
	--platform:anycpu					# Limit the platform to anycpu (default)
	--nooptimizationdata					# Only include optimization information for inlined constructs
	--nointerfacedata					# Don't add a resource to the assembly containing F#-specific metadata
	--sig:					# Print the inferred interface of the assembly to a file
	--reference:					# Reference an assembly
	--win32res:					# Specify a Win32 resource file (.res)
	--win32manifest:					# Specify a Win32 manifest file
	--nowin32manifest					# Do not include the default Win32 manifest
	--resource:					# Embed the specified managed resource
	--linkresource:					# Link the specified resource to this assembly
	--debug+(-g)					# Emit debug information
	--debug-					# Disable --debug
	--optimize+(-O)					# Enable optimizations
	--optimize-					# Disable --optimize
	--tailcalls+					# Enable or disable tailcalls
	--tailcalls-					# Disable --tailcalls
	--deterministic+					# Produce a deterministic assembly
	--deterministic-					# Disable --deterministic
	--crossoptimize+					# Enable or disable cross-module optimizations
	--crossoptimize-					# Disable --crossoptimize
	--warnaserror+					# Report all warnings as errors
	--warnaserror-					# Disable --warnaserror
	--warnaserror+:					# Report specific warnings as errors
	--warnaserror-:					# Disable --warnaserror:
	--nowarn:					# Disable specific warning messages
	--warnon:					# Enable specific warnings that may be off by default
	--consolecolors+					# Output warning and error messages in color
	--consolecolors-					# Disable --consolecolors
	--checked+					# Generate overflow checks
	--checked-					# Disable --checked
	--define:					# Define conditional compilation symbols
	--mlcompatibility					# Ignore ML compatibility warnings
	--nologo					# Suppress compiler copyright message
	--help(-?)					# Display this usage message
	--codepage:					# Specify the codepage used to read source files
	--utf8output					# Output messages in UTF-8 encoding
	--fullpaths					# Output messages with fully qualified paths
	--lib:					# Specify a directory for include path for resolving source files and assemblies
	--simpleresolution					# Resolve assembly references using directory-based rules
	--baseaddress:					# Base address for the library to be built
	--noframework					# Do not reference the default CLI assemblies by default
	--standalone					# Statically link F# library and referenced DLLs into the generated assembly
	--staticlink:					# Statically link the assembly and referenced DLLs that depend on this assembly
	--pdb:					# Name the output debug file
	--highentropyva+					# Enable high-entropy ASLR
	--highentropyva-					# Disable --highentropyva
	--subsystemversion:					# Specify subsystem version of this assembly
	--quotations-debug+					# Emit debug information in quotations
	--quotations-debug-					# Disable --quotations-debug
	...args
]