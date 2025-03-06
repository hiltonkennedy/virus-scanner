                                                                                                                                                                                                 
#!/bin/bash 
SCAN_DIR="/"
MALWARE_DB="/home/hilton/Documents/malware_signature.txt"
QUARANTINE_DIR="/var/quarantine"
SCAN_LOG="scanner.log"

mkdir -p "$QUARANTINE_DIR" 

calculate_hash(){
   sha256sum "$1" | awk '{print $1}'
}

echo "[+] scanning started.... " | tee -a  "$SCAN_LOG"
find "$SCAN_DIR"  -type f | while  IFS= read -r file;do
       if [[ -f "$file" ]];then
          file_hash=$(calculate_hash "$file")
          if grep -q "$file_hash" "$MALWARE_DB"; then
               echo "MALWARE DETECTED IN $file"  | tee -a "$SCAN_LOG"
               mv "$file" "$QUARANTINE_DIR/$(basename "$file").quarantine"
               chmod 000  "$QUARANTINE_DIR/$(basename "$file").quarantine"
               echo "$file moved to $QUARANTINE_DIR " | tee -a "$SCAN_LOG" 
          fi

       fi
done 
EMAIL="hiltonkennedy71.com"
SUBJECT="🚨 Malware Alert: Threat Detected!"
BODY="Malware detected on $(hostname)  at $(date). Check logs at $LOG_FILE"

sleep 2

if [ -f "$QUARANTINE_DIR" ]; then  # Replace this with your detection logic
    echo "Threat found! Logging and sending email..."

    # Log the incident
    echo "$(date) - Malware detected in $(QUARANTINE_DIR)" >> "$LOG_FILE"

    # Send email alert
    echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"

    echo "Email alert sent to $EMAIL."
else
    echo "No threats detected."
fi



echo "scan completed successfully " | tee -a "$SCAN_LOG" 
