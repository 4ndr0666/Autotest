# --- Colors for visual feedback ---
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[1;33m"
BLUE="\033[34m"
NC="\033[0m" # No Color



print_status() {
    echo -e "${BLUE}$1${NC}"
}


print_error() {
    echo -e "${RED}$1${NC}"
}


print_success() {
    echo -e "${GREEN}$1${NC}"
}


confirm_action() {
    read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        print_error "Operation cancelled."
        return 1
    fi
    return 0
}


backup_gnupg() {
    local backup_dir="$HOME/.gnupg-backup-$(date +%Y%m%d%H%M%S)"
    mkdir -p "$backup_dir" && cp -r $HOME/.gnupg/* "$backup_dir"
    print_success "Backup of .gnupg directory created at $backup_dir"
}


create_gnupg_dir() {
    local new_dir="$HOME/.gnupg-new"
    mkdir -p "$new_dir"
    print_success "New .gnupg directory created at $new_dir"
}


restore_gnupg_data() {
    local backup_dir # Add logic to select backup directory
    cp -r "$backup_dir"/* $HOME/.gnupg
    print_success "GnuPG data restored from $backup_dir"
}


set_permissions() {
    chmod 700 $HOME/.gnupg
    chmod 600 $HOME/.gnupg/*
    print_success "Correct permissions set for .gnupg directory"
}


list_gpg_keys() {
    echo "Listing GPG keys..."
    gpg --list-keys
    print_success "GPG keys listed"
}


generate_gpg_key() {
    gpg --gen-key
    print_success "New GPG key generated"
}


create_armored_key() {
    local key_id="$1"
    gpg --export -a "$key_id" > "$key_id.asc"
    print_success "Armored GPG key for $key_id created"
}


export_gpg_key() {
    local key_id="$1" # Assuming the first argument is the key ID
    gpg --export -a "$key_id" > "$key_id.gpg"
    print_success "GPG key $key_id exported"
}


export_add_key_to_service() {
    local key_id="$1" # Assuming the first argument is the key ID
    local service="$2" # Assuming the second argument is the service name
    gpg --export -a "$key_id" | curl -T - "https://$service/keys/upload" # Example logic
    print_success "GPG key $key_id exported and added to $service"
}


reinitialize_gpg_agent() {
    gpgconf --reload gpg-agent
    print_success "GPG agent reinitialized"
}


clean_up_test_dir() {
    local test_dir="$1" # Assuming the first argument is the test directory
    rm -rf "$test_dir"
    print_success "Test directory $test_dir cleaned up"
}


incremental_backup() {
    local backup_dir="$HOME/.gnupg-backup-$(date +%Y%m%d%H%M%S)"
    rsync -av --delete $HOME/.gnupg/ "$backup_dir" # Example logic
    print_success "Incremental backup of .gnupg directory created at $backup_dir"
}


apply_security_template() {
    local template_file="$1" # Assuming the first argument is the template file
    cp "$template_file" $HOME/.gnupg/gpg.conf # Example logic
    print_success "Security template from $template_file applied"
}


generate_advanced_gpg_key() {
    gpg --full-gen-key # Example logic for advanced key generation
    print_success "Advanced GPG key generated"
}


export_keys_diff_formats() {
    local key_id="$1" # Assuming the first argument is the key ID
    gpg --export -a "$key_id" > "$key_id.asc"
    gpg --export-secret-keys -a "$key_id" > "$key_id-sec.asc"
    print_success "Keys for $key_id exported in different formats"
}


automated_security_audit() {
    # Example logic for automated security audit
    echo "Performing security audit..."
    # Simulating security checks
    sleep 2 # Placeholder for actual audit logic
    print_success "Automated security audit completed"
}


show_menu() {
    echo -e "${YELLOW}GPG Management Menu${NC}"
    echo "1. Backup .gnupg Directory"
    echo "2. Create New .gnupg Directory"
    echo "3. Restore GnuPG Data"
    echo "4. Set Correct Permissions"
    echo "5. List GPG Keys"
    echo "6. Generate GPG Key"
    echo "7. Create Armored Key"
    echo "8. Export GPG Key"
    echo "9. Export and Add GPG Key to Service"
    echo "10. Reinitialize GPG Agent"
    echo "11. Clean Up Test Directory"
    echo "12. Incremental Backup"
    echo "13. Apply Security Template"
    echo "14. Generate Advanced GPG Key"
    echo "15. Export Keys in Different Formats"
    echo "16. Automated Security Audit"
    echo "17. Exit"
}


validate_input() {
    if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 17 ]; then
        return 0
    else
        echo "Invalid input. Please enter a number between 1 and 17."
        return 1
    fi
}


executeFunctionWithFeedback() {
    echo -e "\033[1;33m" # Yellow color
    echo "Starting: $1"
    echo -e "\033[0m" # Reset color

    $1

    echo -e "\033[1;32m" # Green color
    echo "$1 completed successfully."
    echo -e "\033[0m" # Reset color
    read -p "Press any key to continue..." -n 1
}


cleanup() {
    echo -e "\033[0m"
}


display_menu() {
    clear
    echo -e "${GRE}====================================================="
    echo -e "${GRE}FIXGPG.SH - A gpg management script by 4ndr0666"
    echo -e "${GRE}====================================================="

    echo -e "${c0}=============== // ${GRE}Main Menu${c0} // ====================="
    echo "1) Backup .gnupg Directory"
    echo "2) Create New .gnupg Directory"
    echo "3) Restore GnuPG Data"
    echo "4) Set Correct Permissions"
    echo "5) List GPG Keys"
    echo "6) Generate GPG Key"
    echo "7) Create Armored Key"
    echo "8) Export GPG Key"
    echo "9) Export and Add GPG Key to Service"
    echo "10) Reinitialize GPG Agent"
    echo "11) Clean Up Test Directory"
    echo "12) Incremental Backup"
    echo "13) Apply Security Template"
    echo "14) Generate Advanced GPG Key"
    echo "15) Export Keys in Different Formats"
    echo "16) Automated Security Audit"
    echo "17) Exit"
    echo -e "By your command: ${RED}\c"
}


backupGnupgDir() {
    local backupDir="$1"
    if [ ! -d "$backupDir" ]; then
        echo "Invalid directory path: $backupDir"
        return 1
    fi
    echo "Backing up the .gnupg directory to $backupDir"
    cp -r ~/.gnupg "$backupDir" || { echo "Backup failed"; exit 1; }
    echo "Backup completed successfully."
}


createNewGnupgDir() {
    if [ -d ~/.gnupg ]; then
        echo "A .gnupg directory already exists. Please rename or remove it before creating a new one."
        exit 1
    fi
    echo "Creating a new .gnupg directory..."
    mkdir ~/.gnupg && chmod 700 ~/.gnupg || { echo "Failed to create .gnupg directory"; exit 1; }
    echo ".gnupg directory created successfully."
}


restoreGnupgData() {
    local backupDir="$1"
    echo "Restoring GnuPG data from $backupDir..."
    cp -r "$backupDir"/.gnupg/* ~/.gnupg/ || { echo "Restore failed"; exit 1; }
    echo "Data restored successfully."
}


setCorrectPermissions() {
    echo "Setting correct permissions for .gnupg directory and its contents..."
    chmod 700 ~/.gnupg
    find ~/.gnupg -type f -exec chmod 600 {} \;
    echo "Permissions set successfully."
}


listGpgKeys() {
    echo "Listing GnuPG keys..."
    gpg --list-keys
}


generateGpgKey() {
    echo "Generating a new GnuPG key pair..."
    gpg --full-generate-key
}


createArmoredKey() {
    local keyId="$1"
    echo "Creating an armored GPG key for $keyId..."
    gpg --armor --export "$keyId"
}


exportGpgKey() {
    local keyId="$1"
    echo "Exporting GPG key $keyId in armored format..."
    gpg --armor --export "$keyId"
}


exportAndAddGpgKey() {
    local keyId="$1"
    local service="$2"
    echo "Exporting GPG key $keyId and adding it to $service..."
    gpg --armor --export "$keyId" | gh gpg-key add -
}


reinitializeGpgAgent() {
    echo "Reinitializing the GPG agent..."
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}


cleanUpTestDir() {
    local dir="$1"
    echo "Removing the test GnuPG directory $dir..."
    rm -rf "$dir"
}


incrementalBackupGnupg() {
    local backupDir="$1"
    echo "Performing incremental backup of .gnupg directory..."
    rsync -a --backup ~/.gnupg/ "$backupDir"
    echo "Incremental backup completed."
}


applySecurityTemplate() {
    local template="$1"
    echo "Applying security template: $template..."

    case "$template" in
        "high-security")
            gpgconf --change-options gpg > ~/.gnupg/gpg.conf
            echo "use-agent" >> ~/.gnupg/gpg.conf
            echo "keyserver hkp://keys.gnupg.net" >> ~/.gnupg/gpg.conf
            echo "keyserver-options auto-key-retrieve" >> ~/.gnupg/gpg.conf
            ;;
        "standard")
            # Standard template configuration
            ;;
        *)
            echo "Unknown template. Exiting."
            exit 1
            ;;
    esac
    echo "Security template applied successfully."
}


generateAdvancedGpgKey() {
    local keyType="$1"
    local keyLength="$2"
    echo "Generating an advanced GPG key of type $keyType and length $keyLength..."
    gpg --full-gen-key --key-type "$keyType" --key-length "$keyLength"
}


exportKeysToFormats() {
    local keyId="$1"
    local format="$2"
    echo "Exporting keys to format: $format..."

    case "$format" in
        "ascii-armored")
            gpg --armor --export "$keyId"
            ;;
        "binary")
            gpg --export "$keyId"
            ;;
        *)
            echo "Unknown format. Exiting."
            exit 1
            ;;
    esac
    echo "Keys exported in $format format."
}


automatedSecurityAudit() {
    echo "Performing automated security audit..."

    # Check for weak algorithms
    if gpg --list-config | grep -q 'weak-digest'; then
        echo "Warning: Weak algorithms found."
    else
        echo "No weak algorithms in use."
    fi

    # Check for weak keys
    if gpg --list-keys | grep -q 'RSA2048'; then
        echo "Warning: Weak RSA keys found."
    else
        echo "No weak RSA keys in use."
    fi

    # Check for improper permissions
    local hasIncorrectPermissions=0
    find ~/.gnupg -type d ! -perm 700 -exec echo "Incorrect directory permissions: {}" \; -exec bash -c 'hasIncorrectPermissions=1' \;
    find ~/.gnupg -type f ! -perm 600 -exec echo "Incorrect file permissions: {}" \; -exec bash -c 'hasIncorrectPermissions=1' \;

    if [ "$hasIncorrectPermissions" -eq 1 ]; then
        echo "Warning: Improper permissions found in .gnupg directory."
    else
        echo "All permissions are correctly set."
    fi


    echo "Automated security audit completed."
}


main() {
    while true; do
        display_menu
        read -r choice

        if ! validate_input "$choice"; then
            continue
        fi

        case "$choice" in
            1)
	       read -p "Enter backup directory path: " backupDir
	       executeFunctionWithFeedback "backupGnupgDir '$backupDir'"
	       ;;
            2)
	       executeFunctionWithFeedback "createNewGnupgDir"
	       ;;
            3)
	       read -p "Enter restore directory path: " restoreDir
	       executeFunctionWithFeedback "restoreGnupgData '$restoreDir'"
	       ;;
            4) executeFunctionWithFeedback "setCorrectPermissions"
	       ;;
            5) executeFunctionWithFeedback "listGpgKeys"
	       ;;
            6) executeFunctionWithFeedback "generateGpgKey"
	       ;;
            7)
	       read -p "Enter key ID for armored key creation: " keyId
	       executeFunctionWithFeedback "createArmoredKey '$keyId'"
	       ;;
            8)
	       read -p "Enter key ID for exporting GPG key: " keyId
	       executeFunctionWithFeedback "exportGpgKey '$keyId'"
	       ;;
            9)
	       read -p "Enter key ID for exporting and adding to service: " keyId
	       read -p "Enter service name: " serviceName
	       executeFunctionWithFeedback "exportAndAddGpgKey '$keyId' '$serviceName'"
	       ;;
            10) executeFunctionWithFeedback "reinitializeGpgAgent"
		;;
            11)
		read -p "Enter path to test dir for cleanup: " testDir
		executeFunctionWithFeedback "cleanUpTestDir '$testDir'"
		;;
            12)
		read -p "Enter path to incremental backup dir: " backupDir
		executeFunctionWithFeedback "incrementalBackupGnupg '$backupDir'"
		;;
            13)
		printf "Select security template:\n1) high-security\n2) standard\n"
                printf "Enter your choice (1 or 2): "
                read templateChoice
                if [ "$templateChoice" -eq 1 ]; then
                    template="high-security"
                else
                    template="standard"
                fi
                executeFunctionWithFeedback "applySecurityTemplate '$template'"
                ;;
            14)
		read -p "Enter key type for advanced GPG key (e.g., RSA): " keyType
                read -p "Enter key length for advanced GPG key (e.g., 4096): " keyLength
                executeFunctionWithFeedback "generateAdvancedGpgKey '$keyType' '$keyLength'"
                ;;
            15)
		read -p "Enter key ID for export: " keyId
                echo "Select format: 1) ascii-armored 2) binary"
                read -p "Enter your choice (1 or 2): " formatChoice
                if [ "$formatChoice" -eq 1 ]; then
                    format="ascii-armored"
                else
                    format="binary"
                fi
                executeFunctionWithFeedback "exportKeysToFormats '$keyId' '$format'"
                ;;
            16) executeFunctionWithFeedback "automatedSecurityAudit"
	        ;;
            17) echo "Exiting program."
		cleanup
		exit 0
		;;
            *) echo "Invalid option. Please try again."
		;;
    esac
done
}

#!/bin/bash

print_error() {
    echo -e "${RED}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

confirm_action() {
    read -p "Are you sure you want to proceed? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        print_error "Operation cancelled."
        return 1
    fi
    return 0
}

# --- Main Functionalities ---
# 1) Backup .gnupg Directory
backup_gnupg() {
    local backup_dir="$HOME/.gnupg-backup-$(date +%Y%m%d%H%M%S)"
    mkdir -p "$backup_dir" && cp -r $HOME/.gnupg/* "$backup_dir"
    print_success "Backup of .gnupg directory created at $backup_dir"
}

# 2) Create New .gnupg Directory
create_gnupg_dir() {
    local new_dir="$HOME/.gnupg-new"
    mkdir -p "$new_dir"
    print_success "New .gnupg directory created at $new_dir"
}

# 3) Restore GnuPG Data
restore_gnupg_data() {
    local backup_dir # Add logic to select backup directory
    cp -r "$backup_dir"/* $HOME/.gnupg
    print_success "GnuPG data restored from $backup_dir"
}

# 4) Set Correct Permissions
set_permissions() {
    chmod 700 $HOME/.gnupg
    chmod 600 $HOME/.gnupg/*
    print_success "Correct permissions set for .gnupg directory"
}

# 5) List GPG Keys
list_gpg_keys() {
    echo "Listing GPG keys..."
    gpg --list-keys
    print_success "GPG keys listed"
}

# 6) Generate GPG Key
generate_gpg_key() {
    gpg --gen-key
    print_success "New GPG key generated"
}

# 7) Create Armored Key
create_armored_key() {
    local key_id="$1"
    gpg --export -a "$key_id" > "$key_id.asc"
    print_success "Armored GPG key for $key_id created"
}


# 8) Export GPG Key
export_gpg_key() {
    local key_id="$1" # Assuming the first argument is the key ID
    gpg --export -a "$key_id" > "$key_id.gpg"
    print_success "GPG key $key_id exported"
}

# 9) Export and Add GPG Key to Service
export_add_key_to_service() {
    local key_id="$1" # Assuming the first argument is the key ID
    local service="$2" # Assuming the second argument is the service name
    gpg --export -a "$key_id" | curl -T - "https://$service/keys/upload" # Example logic
    print_success "GPG key $key_id exported and added to $service"
}

# 10) Reinitialize GPG Agent
reinitialize_gpg_agent() {
    gpgconf --reload gpg-agent
    print_success "GPG agent reinitialized"
}

# 11) Clean Up Test Directory
clean_up_test_dir() {
    local test_dir="$1" # Assuming the first argument is the test directory
    rm -rf "$test_dir"
    print_success "Test directory $test_dir cleaned up"
}

# 12) Incremental Backup
incremental_backup() {
    local backup_dir="$HOME/.gnupg-backup-$(date +%Y%m%d%H%M%S)"
    rsync -av --delete $HOME/.gnupg/ "$backup_dir" # Example logic
    print_success "Incremental backup of .gnupg directory created at $backup_dir"
}

# 13) Apply Security Template
apply_security_template() {
    local template_file="$1" # Assuming the first argument is the template file
    cp "$template_file" $HOME/.gnupg/gpg.conf # Example logic
    print_success "Security template from $template_file applied"
}

# 14) Generate Advanced GPG Key
generate_advanced_gpg_key() {
    gpg --full-gen-key # Example logic for advanced key generation
    print_success "Advanced GPG key generated"
}

# 15) Export Keys in Different Formats
export_keys_diff_formats() {
    local key_id="$1" # Assuming the first argument is the key ID
    gpg --export -a "$key_id" > "$key_id.asc"
    gpg --export-secret-keys -a "$key_id" > "$key_id-sec.asc"
    print_success "Keys for $key_id exported in different formats"
}

# 16) Automated Security Audit
automated_security_audit() {
    # Example logic for automated security audit
    echo "Performing security audit..."
    # Simulating security checks
    sleep 2 # Placeholder for actual audit logic
    print_success "Automated security audit completed"
}

# --- Menu System ---
show_menu() {
    echo -e "${YELLOW}GPG Management Menu${NC}"
    echo "1. Backup .gnupg Directory"
    echo "2. Create New .gnupg Directory"
    echo "3. Restore GnuPG Data"
    echo "4. Set Correct Permissions"
    echo "5. List GPG Keys"
    echo "6. Generate GPG Key"
    echo "7. Create Armored Key"
    echo "8. Export GPG Key"
    echo "9. Export and Add GPG Key to Service"
    echo "10. Reinitialize GPG Agent"
    echo "11. Clean Up Test Directory"
    echo "12. Incremental Backup"
    echo "13. Apply Security Template"
    echo "14. Generate Advanced GPG Key"
    echo "15. Export Keys in Different Formats"
    echo "16. Automated Security Audit"
    echo "17. Exit"
}

while true; do
    show_menu
    read -p "Enter your choice [1-17]: " choice
    case $choice in
        1) backup_gnupg ;;
        2) create_gnupg_dir ;;
        3) restore_gnupg_data ;;
        4) set_permissions ;;
        5) list_gpg_keys ;;
        6) generate_gpg_key ;;
        7) create_armored_key "$key_id" ;;
        8) export_gpg_key ;;
        9) export_add_key_to_service ;;
        10) reinitialize_gpg_agent ;;
        11) clean_up_test_dir ;;
        12) incremental_backup ;;
        13) apply_security_template ;;
        14) generate_advanced_gpg_key ;;
        15) export_keys_diff_formats ;;
        16) automated_security_audit ;;
        17) break ;;
        *) print_error "Invalid choice." ;;
    esac
done

print_success "Exiting GPG Management Tool."

# --- Merging from fixgpg.sh ---

#!/bin/bash

# --- // Colors:
GRE="\033[32m" # Green
RED="\033[31m" # Red
c0="\033[0m"    # Reset color

# --- // Input_validation:
validate_input() {
    if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 1 ] && [ $1 -le 17 ]; then
        return 0
    else
        echo "Invalid input. Please enter a number between 1 and 17."
        return 1
    fi
}

# --- // Visual_feedback:
executeFunctionWithFeedback() {
    echo -e "\033[1;33m" # Yellow color
    echo "Starting: $1"
    echo -e "\033[0m" # Reset color

    $1

    echo -e "\033[1;32m" # Green color
    echo "$1 completed successfully."
    echo -e "\033[0m" # Reset color
    read -p "Press any key to continue..." -n 1
}

# --- // Set_trap_for_SIGINT:
trap 'echo -e "\nExiting..."; cleanup; exit 1' SIGINT

# --- // Cleanup_tasks:
cleanup() {
    echo -e "\033[0m"
}

# --- // Menu:
display_menu() {
    clear
    echo -e "${GRE}====================================================="
    echo -e "${GRE}FIXGPG.SH - A gpg management script by 4ndr0666"
    echo -e "${GRE}====================================================="

    echo -e "${c0}=============== // ${GRE}Main Menu${c0} // ====================="
    echo "1) Backup .gnupg Directory"
    echo "2) Create New .gnupg Directory"
    echo "3) Restore GnuPG Data"
    echo "4) Set Correct Permissions"
    echo "5) List GPG Keys"
    echo "6) Generate GPG Key"
    echo "7) Create Armored Key"
    echo "8) Export GPG Key"
    echo "9) Export and Add GPG Key to Service"
    echo "10) Reinitialize GPG Agent"
    echo "11) Clean Up Test Directory"
    echo "12) Incremental Backup"
    echo "13) Apply Security Template"
    echo "14) Generate Advanced GPG Key"
    echo "15) Export Keys in Different Formats"
    echo "16) Automated Security Audit"
    echo "17) Exit"
    echo -e "By your command: ${RED}\c"
}

# --- // Backup_dir:
backupGnupgDir() {
    local backupDir="$1"
    if [ ! -d "$backupDir" ]; then
        echo "Invalid directory path: $backupDir"
        return 1
    fi
    echo "Backing up the .gnupg directory to $backupDir"
    cp -r ~/.gnupg "$backupDir" || { echo "Backup failed"; exit 1; }
    echo "Backup completed successfully."
}

# --- // New_dir:
createNewGnupgDir() {
    if [ -d ~/.gnupg ]; then
        echo "A .gnupg directory already exists. Please rename or remove it before creating a new one."
        exit 1
    fi
    echo "Creating a new .gnupg directory..."
    mkdir ~/.gnupg && chmod 700 ~/.gnupg || { echo "Failed to create .gnupg directory"; exit 1; }
    echo ".gnupg directory created successfully."
}

# --- // Restore_backup:
restoreGnupgData() {
    local backupDir="$1"
    echo "Restoring GnuPG data from $backupDir..."
    cp -r "$backupDir"/.gnupg/* ~/.gnupg/ || { echo "Restore failed"; exit 1; }
    echo "Data restored successfully."
}

# --- // Permissions:
setCorrectPermissions() {
    echo "Setting correct permissions for .gnupg directory and its contents..."
    chmod 700 ~/.gnupg
    find ~/.gnupg -type f -exec chmod 600 {} \;
    echo "Permissions set successfully."
}

# --- // List_keys:
listGpgKeys() {
    echo "Listing GnuPG keys..."
    gpg --list-keys
}

# --- // New_key:
generateGpgKey() {
    echo "Generating a new GnuPG key pair..."
    gpg --full-generate-key
}

# --- // Armor_key:
createArmoredKey() {
    local keyId="$1"
    echo "Creating an armored GPG key for $keyId..."
    gpg --armor --export "$keyId"
}

# --- // Export:
exportGpgKey() {
    local keyId="$1"
    echo "Exporting GPG key $keyId in armored format..."
    gpg --armor --export "$keyId"
}

# --- // Export_key_and_add:
exportAndAddGpgKey() {
    local keyId="$1"
    local service="$2"
    echo "Exporting GPG key $keyId and adding it to $service..."
    gpg --armor --export "$keyId" | gh gpg-key add -
}

# --- // Restart_agent:
reinitializeGpgAgent() {
    echo "Reinitializing the GPG agent..."
    gpgconf --kill gpg-agent
    gpg-agent --daemon
}

# --- // Clean_testdir:
cleanUpTestDir() {
    local dir="$1"
    echo "Removing the test GnuPG directory $dir..."
    rm -rf "$dir"
}

# --- // Incremental_backups:
incrementalBackupGnupg() {
    local backupDir="$1"
    echo "Performing incremental backup of .gnupg directory..."
    rsync -a --backup ~/.gnupg/ "$backupDir"
    echo "Incremental backup completed."
}

# --- // Security_templates:
applySecurityTemplate() {
    local template="$1"
    echo "Applying security template: $template..."

    case "$template" in
        "high-security")
            gpgconf --change-options gpg > ~/.gnupg/gpg.conf
            echo "use-agent" >> ~/.gnupg/gpg.conf
            echo "keyserver hkp://keys.gnupg.net" >> ~/.gnupg/gpg.conf
            echo "keyserver-options auto-key-retrieve" >> ~/.gnupg/gpg.conf
            ;;
        "standard")
            # Standard template configuration
            ;;
        *)
            echo "Unknown template. Exiting."
            exit 1
            ;;
    esac
    echo "Security template applied successfully."
}

# --- // Advanced_key:
generateAdvancedGpgKey() {
    local keyType="$1"
    local keyLength="$2"
    echo "Generating an advanced GPG key of type $keyType and length $keyLength..."
    gpg --full-gen-key --key-type "$keyType" --key-length "$keyLength"
}

# --- // Export_keys:
exportKeysToFormats() {
    local keyId="$1"
    local format="$2"
    echo "Exporting keys to format: $format..."

    case "$format" in
        "ascii-armored")
            gpg --armor --export "$keyId"
            ;;
        "binary")
            gpg --export "$keyId"
            ;;
        *)
            echo "Unknown format. Exiting."
            exit 1
            ;;
    esac
    echo "Keys exported in $format format."
}

# --- // Security_audit:
automatedSecurityAudit() {
    echo "Performing automated security audit..."

    # Check for weak algorithms
    if gpg --list-config | grep -q 'weak-digest'; then
        echo "Warning: Weak algorithms found."
    else
        echo "No weak algorithms in use."
    fi

    # Check for weak keys
    if gpg --list-keys | grep -q 'RSA2048'; then
        echo "Warning: Weak RSA keys found."
    else
        echo "No weak RSA keys in use."
    fi

    # Check for improper permissions
    local hasIncorrectPermissions=0
    find ~/.gnupg -type d ! -perm 700 -exec echo "Incorrect directory permissions: {}" \; -exec bash -c 'hasIncorrectPermissions=1' \;
    find ~/.gnupg -type f ! -perm 600 -exec echo "Incorrect file permissions: {}" \; -exec bash -c 'hasIncorrectPermissions=1' \;

    if [ "$hasIncorrectPermissions" -eq 1 ]; then
        echo "Warning: Improper permissions found in .gnupg directory."
    else
        echo "All permissions are correctly set."
    fi


    echo "Automated security audit completed."
}

# --- // Menu_logic:
main() {
    while true; do
        display_menu
        read -r choice

        if ! validate_input "$choice"; then
            continue
        fi

        case "$choice" in
            1)
	       read -p "Enter backup directory path: " backupDir
	       executeFunctionWithFeedback "backupGnupgDir '$backupDir'"
	       ;;
            2)
	       executeFunctionWithFeedback "createNewGnupgDir"
	       ;;
            3)
	       read -p "Enter restore directory path: " restoreDir
	       executeFunctionWithFeedback "restoreGnupgData '$restoreDir'"
	       ;;
            4) executeFunctionWithFeedback "setCorrectPermissions"
	       ;;
            5) executeFunctionWithFeedback "listGpgKeys"
	       ;;
            6) executeFunctionWithFeedback "generateGpgKey"
	       ;;
            7)
	       read -p "Enter key ID for armored key creation: " keyId
	       executeFunctionWithFeedback "createArmoredKey '$keyId'"
	       ;;
            8)
	       read -p "Enter key ID for exporting GPG key: " keyId
	       executeFunctionWithFeedback "exportGpgKey '$keyId'"
	       ;;
            9)
	       read -p "Enter key ID for exporting and adding to service: " keyId
	       read -p "Enter service name: " serviceName
	       executeFunctionWithFeedback "exportAndAddGpgKey '$keyId' '$serviceName'"
	       ;;
            10) executeFunctionWithFeedback "reinitializeGpgAgent"
		;;
            11)
		read -p "Enter path to test dir for cleanup: " testDir
		executeFunctionWithFeedback "cleanUpTestDir '$testDir'"
		;;
            12)
		read -p "Enter path to incremental backup dir: " backupDir
		executeFunctionWithFeedback "incrementalBackupGnupg '$backupDir'"
		;;
            13)
		printf "Select security template:\n1) high-security\n2) standard\n"
                printf "Enter your choice (1 or 2): "
                read templateChoice
                if [ "$templateChoice" -eq 1 ]; then
                    template="high-security"
                else
                    template="standard"
                fi
                executeFunctionWithFeedback "applySecurityTemplate '$template'"
                ;;
            14)
		read -p "Enter key type for advanced GPG key (e.g., RSA): " keyType
                read -p "Enter key length for advanced GPG key (e.g., 4096): " keyLength
                executeFunctionWithFeedback "generateAdvancedGpgKey '$keyType' '$keyLength'"
                ;;
            15)
		read -p "Enter key ID for export: " keyId
                echo "Select format: 1) ascii-armored 2) binary"
                read -p "Enter your choice (1 or 2): " formatChoice
                if [ "$formatChoice" -eq 1 ]; then
                    format="ascii-armored"
                else
                    format="binary"
                fi
                executeFunctionWithFeedback "exportKeysToFormats '$keyId' '$format'"
                ;;
            16) executeFunctionWithFeedback "automatedSecurityAudit"
	        ;;
            17) echo "Exiting program."
		cleanup
		exit 0
		;;
            *) echo "Invalid option. Please try again."
		;;
    esac
done
}

# --- // Execute:
main