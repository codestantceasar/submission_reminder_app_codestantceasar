#!/bin/bash

# Set up the directory structure
mkdir -p submission_reminder_app/{app,modules,assets,config}

# Create and populate the config.env file
cat <<EOL > submission_reminder_app/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Create and populate the reminder.sh file in the app directory
cat <<EOL > submission_reminder_app/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOL

# Make reminder.sh executable
chmod +x submission_reminder_app/app/reminder.sh

# Create and populate the functions.sh file in the modules directory
cat <<EOL > submission_reminder_app/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL

# Make functions.sh executable
chmod +x submission_reminder_app/modules/functions.sh

# Create and populate the submissions.txt file in the assets directory
cat <<EOL > submission_reminder_app/assets/submissions.txt
student, assignment, submission status
here, Shell Navigation, submitted
Noel, Shell Navigation, not submitted
Alice, Shell Navigation, not submitted
Bob, Shell Navigation, submitted
Eve, Shell Navigation, not submitted
Trent, Shell Navigation, submitted
Mallory, Shell Navigation, not submitted
EOL

# Create the startup.sh file in the root of submission_reminder_app
cat <<EOL > submission_reminder_app/startup.sh
#!/bin/bash

# Navigate to the app directory and execute the reminder script
cd app
./reminder.sh
EOL

# Make startup.sh executable
chmod +x submission_reminder_app/startup.sh

