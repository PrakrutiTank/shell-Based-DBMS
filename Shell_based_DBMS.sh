Insert_table_Stuct()
{
        echo "Creating Table.."
        read -p "Enter table name:" tn
        if [[ -f "$tn.txt" ]]; then
                echo "Table already exists.."
        else
                declare -a Attri
                read -p "enter number of column:" n
                read -p "Enter primary key:" Attri[0]

                for ((i=1; i<n; i++)); do
                        read -p " Enter column($((i+1))):" Attri[i]
                done
                echo -e "${Attri[*]}" | tr ' ' '\t' >> "$tn.txt"
                echo "Table structure saved in $tn.txt"
        fi
}

Insert_Row(){
    read -p "Enter Table name:" tn
    if [[ -f "$tn.txt" ]]; then
        head -n 1 "$tn.txt" | awk '{print "Primary Key:", $1, "\nAll Attributes:", $0}'
        read -r Attri_row < "$tn.txt"

        IFS=$'\t'
        addrow=1
        declare -a RowData

        while [[ $addrow -ne 0 ]]; do
            i=0
            for word in $Attri_row; do
                read -p "Enter $word: " RowData[i]
                ((i++))
            done
            echo -e "${RowData[*]}" | tr ' ' '\t' >> "$tn.txt"
            read -p "Do you want to add another row? (1 for yes, 0 for no): " addrow
        done

    else
        echo "Table Doesn't exist.."
    fi
}

View_table(){
        echo "Viewing Table.."
        read -p "Enter table name:" tn
        if [[ -f "$tn.txt" ]]; then
                echo "Enter 1 to view whole table"
                echo "Enter 2 to view perticular Column"
                read -p "Enter:" ch
                if [[  "$ch" -eq 1 ]]; then
                        cat "$tn.txt"
                else
                    total_lines=$(wc -l < "$tn.txt")
                    if [[ "$total_lines" -eq 1 ]]; then
                        echo "Table '$tn' is empty."
                    else
                        head -n 1 "$tn.txt" | awk '{print "\nAll Attributes:", $0}'
                        read -p "Enter total Attributes to be printed:" x
                        declare -a ColNumber
                        for ((i=0; i<x; i++)); do
                                read -p " Enter column number($((i+1))):" ColNumber[i]
                        done
                        awk_cmd='{ print'
                            for col in "${ColNumber[@]}"; do
                                awk_cmd+=" \$${col},"
                            done
                        awk_cmd="${awk_cmd%,} }"
                        awk "$awk_cmd" "$tn.txt"
                     fi
                fi
        else
                echo "Table does not exist"
        fi
}
search_data() {
        read -p "Enter table name: " tn
        if [[ -f "$tn.txt" ]]; then
                total_lines=$(wc -l < "$tn.txt")
                if [[ "$total_lines" -eq 1 ]]; then
                        echo "Table '$tn' is empty."
                else
                        echo "Table '$tn' contains data."
                        head -n 1 "$tn.txt"
                        read -p "Enter Primary Key value to search: " key
                        echo " "
                        head -n 1 "$tn.txt"
                        grep -w "^$key" "$tn.txt" || echo "No matching record found."
                fi
        else
                 echo "Table does not exist.."
        fi
}

sort_data(){
        read -p "Enter table name: " tn
        total_lines=$(wc -l < "$tn.txt")
        if [[ "$total_lines" -eq 1 ]]; then
            echo "Table '$tn' is empty."
        else
                head -n 1 "$tn.txt"
                read -p "Enter column number to sort by: " col
                (head -n 1 "$tn.txt"; tail -n +2 "$tn.txt" | sort -k"$col","$col" -n)
        fi
}

modify_data() {
    read -p "Enter table name: " tn
    [[ -f "$tn.txt" ]] || { echo "Table does not exist."; return; }
    total_lines=$(wc -l < "$tn.txt")
    if [[ "$total_lines" -eq 1 ]]; then
            echo "Table '$tn' is empty."
            return;
    fi
    head -n 1 "$tn.txt"
    read -p "Enter Primary Key value to modify: " key
    grep -w "^$key" "$tn.txt" || { echo "No matching record found."; return; }
    read -p "Enter new data (Tab-separated): " new_row
    sed -i "/^$key/d" "$tn.txt"
    echo "$new_row" >> "$tn.txt"

    echo "Record updated successfully!"
}

delete_data(){
 read -p "Enter table name: " tn
    [[ -f "$tn.txt" ]] || { echo "Table does not exist."; return; }
    total_lines=$(wc -l < "$tn.txt")
    if [[ "$total_lines" -eq 1 ]]; then
            echo "Table '$tn' is empty."
            return;
    fi
    head -n 1 "$tn.txt"
    read -p "Enter Primary Key value to modify: " key
    grep -w "^$key" "$tn.txt" || { echo "No matching record found."; return; }
    sed -i "/^$key/d" "$tn.txt"
    echo "Record Deleted successfully!"
}

List_Table(){
        echo "listing Table..."
        ls *.txt
}

is_table_empty() {
    read -p "Enter table name: " tn
    if [[ -f "$tn.txt" ]]; then
        total_lines=$(wc -l < "$tn.txt")
        if [[ "$total_lines" -eq 1 ]]; then
            echo "Table '$tn' is empty"
        else
            echo "Table '$tn' contains data."
        fi
    else
        echo "Table does not exist."
    fi
}

echo "Display Options:"
echo "1) Insert Table Structure"
echo "2) Insert Row"
echo "3) View Table"
echo "4) Search Data"
echo "5) Sort Data"
echo "6) Modify Data"
echo "7) Delete Data"
echo "8) List Tables"
echo "9) Is Table Empty or Not"
echo "10) Exit"

while true; do
        read -p "Enter Choice:" choice
        case $choice in
                1) Insert_table_Stuct;;
                2) Insert_Row;;
                3) View_table;;
                4) search_data;;
                5) sort_data;;
                6) modify_data;;
                7) delete_data;;
                8) List_Table;;
                9) is_table_empty;;
                10) break;;
                *) echo "Invalid Choice.."
        esac
done
