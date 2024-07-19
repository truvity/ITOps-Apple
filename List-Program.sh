#!/bin/zsh

#check processor_type
processor_type=$(uname -p)


if [ "$processor_type" = "i386" ] || [ "$processor_type" = "x86_64" ]; then
    exit 0;
fi

#Set name Company
Company=$Company

#Set group
Group=$Group


#Truvity
if [ "$Company" = "Truvity" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		export programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
			whatsapp
		# Add other programs here
		)
		
		
		# List of programs-cli to install via Homebrew
		export programs_cli=(
			speedtest-cli
		# Add other programs here
		)
		
	fi	
	
fi

#Finerbase
if [ "$Company" = "Finerbase" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		export programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
			whatsapp
		# Add other programs here
		)
		
		# List of programs-cli to install via Homebrew
		export programs_cli=(
			speedtest-cli
		# Add other programs here
		)
		
	fi	
	
	if [ "$Group" = "Microsoft_Office" ]; then
	# List of programs-gui to install via Homebrew
		export programs_gui=(
			microsoft-office-businesspro
		# Add other programs here
		)
		
	fi
fi

#Datagrid
if [ "$Company" = "Datagrid" ]; then

	if [ "$Group" = "All" ]; then
	
		# List of programs-gui to install via Homebrew
		export programs_gui=(
			google-chrome
			slack
			1password
			telegram-desktop
			zoom
			google-drive
			anydesk
		# Add other programs here
		)
		
		# List of programs-cli to install via Homebrew
		export programs_cli=(
			speedtest-cli
		# Add other programs here
		)

	fi	
	
fi

set +x
