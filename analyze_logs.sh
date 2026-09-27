#!/usr/bin/env bash

LOG_FILE="acces.log"
COUNT=501

IPS=("8.8.8.8" "8.8.4.4" "1.1.1.1" "192.168.0.1" "192.168.0.19")
HTTP_METHODS=("GET" "POST" "PUT" "DELETE" "PATCH")
ENDPOINTS=("/api/v1/user" "/api/v2/ticket" "/api/v1/order" "/api/v2/account" "/api/v3/contract")
STATUSES=("200" "201" "200" "201" "200" "201" "200" "201" "301" "422" "400" "404" "401" "500" "503")

echo "generate logs..."
{
	for ((i=1;i<=COUNT;i++)); do
		IP=${IPS[$RANDOM % ${#IPS[@]}]}
		HTTP_METHOD=${HTTP_METHODS[$RANDOM % ${#HTTP_METHODS[@]}]}
		ENDPOINT=${ENDPOINTS[$RANDOM % ${#ENDPOINTS[@]}]}
		STATUS=${STATUSES[$RANDOM % ${#STATUSES[@]}]}
		
		DAY=$(printf "%02d" $((RANDOM % 30)))
		HOUR=$(printf "%02d" $((RANDOM % 24)))
		MIN=$(printf "%02d" $((RANDOM % 60)))
		SEC=$(printf "%02d" $((RANDOM % 60)))
		
		echo "$IP - - [$DAY/Sept/2026:$HOUR:$MIN:$SEC] \"$METHOD $ENDPOINT HTTP/1.1\" $STATUS" 
	done
} > "$LOG_FILE"

echo "$COUNT records was added to $LOG_FILE"
echo "==============="
echo "analyze $LOG_FILE..."
echo "records count: $(awk 'END {print NR}' $LOG_FILE)"
echo ""
echo "TOP-3 ip:"
# достаем только ip регуляркой
# сортируем по возрастанию(чтобы uniq правильно посчитал)
# считаем повторения
# сортируем по количеству как числу в убывающем порядке
# берем верхние 3
# печатаем результат форматируя строку с awk
grep -E -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' $LOG_FILE | sort | uniq -c | sort -nr |head -n 3 \
	| awk '{printf "- %d requests %s \n", $1, $2}' 
echo ""
echo "http errors:"
echo "4xx: $(grep -E -c '4[0-9]{2}$' $LOG_FILE)"
echo "5xx: $(grep -E -c '5[0-9]{2}$' $LOG_FILE)"
