#!/bin/bash

# Leer valores de /proc/stat antes de la pausa
cpu_before=($(grep 'cpu ' /proc/stat))
idle_before=${cpu_before[4]}
total_before=0

for value in "${cpu_before[@]:1}"; do
  total_before=$((total_before + value))
done

# Esperar 1 segundo
sleep 1

# Leer valores de /proc/stat después de la pausa
cpu_after=($(grep 'cpu ' /proc/stat))
idle_after=${cpu_after[4]}
total_after=0

for value in "${cpu_after[@]:1}"; do
  total_after=$((total_after + value))
done

# Calcular la diferencia
idle_diff=$((idle_after - idle_before))
total_diff=$((total_after - total_before))
cpu_usage=$(awk "BEGIN {printf \"%.1f\", (1 - $idle_diff / $total_diff) * 100}")

# Obtener el porcentaje de uso de RAM
ram_total=$(free -m | awk '/Mem:/ {print $2}')
ram_used=$(free -m | awk '/Mem:/ {print $3}')
ram_usage=$(awk "BEGIN {printf \"%.1f\", ($ram_used/$ram_total)*100}")

# Imprimir con formato de colores de Polybar
echo "%{F#1bbf3e}󰻠 CPU%{F#ffffff} $cpu_usage% | %{F#e51d0b}󰍛 RAM%{F#ffffff} $ram_usage%"
