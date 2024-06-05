#!/bin/bash

# Student Management System using shell
# Md. Kawsar Ahamed
# 213902013
# Green University

DATA_FILE="students.txt"

first_time=1
function header() {
    if [ "$first_time" -eq 1 ]; then
        clear
        first_time=0
    else
        echo "Do you want to clear the screen? (y/n):"
        read clear_screen
        if [[ "$clear_screen" == "y" || "$clear_screen" == "Y" ]]; then
            clear
        fi
    fi
    echo "=========================================="
    echo "           Student Management System      "
    echo "=========================================="
}

function calculate_grade() {
    marks=$1
    grade=""

    if (( marks < 40 )); then
        grade="F"
    elif (( marks < 45 )); then
        grade="D"
    elif (( marks < 50 )); then
        grade="C"
    elif (( marks < 55 )); then
        grade="C+"
    elif (( marks < 60 )); then
        grade="B-"
    elif (( marks < 65 )); then
        grade="B"
    elif (( marks < 70 )); then
        grade="B+"
    elif (( marks < 75 )); then
        grade="A-"
    elif (( marks < 80 )); then
        grade="A"
    else
        grade="A+"
    fi

    echo $grade
}

function create_student() {
    while true; do
        echo "Enter student ID:"
        read student_id

        if grep -q "^$student_id " $DATA_FILE; then
            echo "Duplicate ID found. Please use another ID."
        else
            break
        fi
    done

    echo "Enter student name:"
    read student_name
    echo "Enter student address:"
    read student_address
    echo "Enter student course:"
    read student_course

    while true; do
        echo "Enter student marks:"
        read student_marks
        if (( student_marks <= 100 )); then
            break
        else
            echo "Marks cannot be greater than 100. Please enter valid marks."
        fi
    done

    echo "$student_id $student_name $student_address $student_course $student_marks" >> $DATA_FILE
    echo "Student created successfully with ID: $student_id"
}

function edit_student() {
    echo "Enter student ID to edit:"
    read student_id

    if grep -q "^$student_id " $DATA_FILE; then
        echo "Enter new student name:"
        read student_name
        echo "Enter new student address:"
        read student_address
        echo "Enter new student course:"
        read student_course

        while true; do
            echo "Enter new student marks:"
            read student_marks
            if (( student_marks <= 100 )); then
                break
            else
                echo "Marks cannot be greater than 100. Please enter valid marks."
            fi
        done

        sed -i "/^$student_id /c\\$student_id $student_name $student_address $student_course $student_marks" $DATA_FILE
        echo "Student information updated successfully."
    else
        echo "Student ID not found."
    fi
}

function delete_student() {
    echo "Enter student ID to delete:"
    read student_id

    if grep -q "^$student_id " $DATA_FILE; then
        sed -i "/^$student_id /d" $DATA_FILE
        echo "Student deleted successfully."
    else
        echo "Student ID not found."
    fi
}

function view_students() {
    echo "================ Student List ================"
    echo -e "ID\tName\t\tAddress\t\tCourse\t\tMarks\tGrade"
    sort -k1 -n $DATA_FILE | while read -r line
    do
        id=$(echo $line | awk '{print $1}')
        name=$(echo $line | awk '{print $2}')
        address=$(echo $line | awk '{print $3}')
        course=$(echo $line | awk '{print $4}')
        marks=$(echo $line | awk '{print $5}')
        grade=$(calculate_grade $marks)
        echo -e "$id\t$name\t\t$address\t\t$course\t\t$marks\t$grade"
    done
}

function search_student() {
    echo "Enter student ID to search:"
    read student_id

    if grep -q "^$student_id " $DATA_FILE; then
        grep "^$student_id " $DATA_FILE | while read -r line
        do
            id=$(echo $line | awk '{print $1}')
            name=$(echo $line | awk '{print $2}')
            address=$(echo $line | awk '{print $3}')
            course=$(echo $line | awk '{print $4}')
            marks=$(echo $line | awk '{print $5}')
            grade=$(calculate_grade $marks)
            echo "ID: $id"
            echo "Name: $name"
            echo "Address: $address"
            echo "Course: $course"
            echo "Marks: $marks"
            echo "Grade: $grade"
        done
    else
        echo "No data found for student ID: $student_id"
    fi
}

function search_student_by_name() {
    echo "Enter student name to search:"
    read student_name

    if grep -i "$student_name" $DATA_FILE; then
        grep -i "$student_name" $DATA_FILE | while read -r line
        do
            id=$(echo $line | awk '{print $1}')
            name=$(echo $line | awk '{print $2}')
            address=$(echo $line | awk '{print $3}')
            course=$(echo $line | awk '{print $4}')
            marks=$(echo $line | awk '{print $5}')
            grade=$(calculate_grade $marks)
            echo "ID: $id"
            echo "Name: $name"
            echo "Address: $address"
            echo "Course: $course"
            echo "Marks: $marks"
            echo "Grade: $grade"
        done
    else
        echo "No data found for student name: $student_name"
    fi
}

function view_statistics() {
    total_marks=0
    count=0
    highest_marks=0
    lowest_marks=100
    grade_counts=(0 0 0 0 0 0 0 0 0 0)  # F, D, C, C+, B-, B, B+, A-, A, A+

    while read -r line; do
        marks=$(echo $line | awk '{print $5}')
        total_marks=$((total_marks + marks))
        count=$((count + 1))
        if (( marks > highest_marks )); then
            highest_marks=$marks
        fi
        if (( marks < lowest_marks )); then
            lowest_marks=$marks
        fi
        grade=$(calculate_grade $marks)
        case $grade in
            "F") grade_counts[0]=$((grade_counts[0] + 1)) ;;
            "D") grade_counts[1]=$((grade_counts[1] + 1)) ;;
            "C") grade_counts[2]=$((grade_counts[2] + 1)) ;;
            "C+") grade_counts[3]=$((grade_counts[3] + 1)) ;;
            "B-") grade_counts[4]=$((grade_counts[4] + 1)) ;;
            "B") grade_counts[5]=$((grade_counts[5] + 1)) ;;
            "B+") grade_counts[6]=$((grade_counts[6] + 1)) ;;
            "A-") grade_counts[7]=$((grade_counts[7] + 1)) ;;
            "A") grade_counts[8]=$((grade_counts[8] + 1)) ;;
            "A+") grade_counts[9]=$((grade_counts[9] + 1)) ;;
        esac
    done < $DATA_FILE

    if (( count == 0 )); then
        echo "No data to display statistics."
        return
    fi

    average_marks=$((total_marks / count))
    echo "Total Students: $count"
    echo "Average Marks: $average_marks"
    echo "Highest Marks: $highest_marks"
    echo "Lowest Marks: $lowest_marks"
    echo "Grade Distribution: "
    echo "F: ${grade_counts[0]}"
    echo "D: ${grade_counts[1]}"
    echo "C: ${grade_counts[2]}"
    echo "C+: ${grade_counts[3]}"
    echo "B-: ${grade_counts[4]}"
    echo "B: ${grade_counts[5]}"
    echo "B+: ${grade_counts[6]}"
    echo "A-: ${grade_counts[7]}"
    echo "A: ${grade_counts[8]}"
    echo "A+: ${grade_counts[9]}"
}

function sort_students() {
    echo "Sort students by:"
    echo "1. Name"
    echo "2. Marks"
    echo "Enter your choice:"
    read sort_choice

    case $sort_choice in
        1) sort_option="2" ;;  # sort by name
        2) sort_option="5" ;;  # sort by marks
        *) echo "Invalid choice"; return ;;
    esac

    echo "================ Sorted Student List ================"
    echo -e "ID\tName\t\tAddress\t\tCourse\t\tMarks\tGrade"
    if [ "$sort_option" -eq "2" ]; then
        sort -k$sort_option $DATA_FILE | while read -r line
        do
            id=$(echo $line | awk '{print $1}')
            name=$(echo $line | awk '{print $2}')
            address=$(echo $line | awk '{print $3}')
            course=$(echo $line | awk '{print $4}')
            marks=$(echo $line | awk '{print $5}')
            grade=$(calculate_grade $marks)
            echo -e "$id\t$name\t\t$address\t\t$course\t\t$marks\t$grade"
        done
    else
        sort -k$sort_option -r $DATA_FILE | while read -r line
        do
            id=$(echo $line | awk '{print $1}')
            name=$(echo $line | awk '{print $2}')
            address=$(echo $line | awk '{print $3}')
            course=$(echo $line | awk '{print $4}')
            marks=$(echo $line | awk '{print $5}')
            grade=$(calculate_grade $marks)
            echo -e "$id\t$name\t\t$address\t\t$course\t\t$marks\t$grade"
        done
    fi
}

function add_comment() {
    echo "Enter student ID to add comment:"
    read student_id

    if grep -q "^$student_id " $DATA_FILE; then
        echo "Enter comment:"
        read comment
        sed -i "/^$student_id / s/$/ $comment/" $DATA_FILE
        echo "Comment added successfully."
    else
        echo "Student ID not found."
    fi
}

function backup_data() {
    backup_file="students_backup.txt"
    cp $DATA_FILE $backup_file
    echo "Backup created as $backup_file."
}

function restore_data() {
    backup_file="students_backup.txt"
    if [ -f $backup_file ]; then
        cp $backup_file $DATA_FILE
        echo "Data restored from $backup_file."
    else
        echo "No backup file found."
    fi
}

function main_menu() {
    while true; do
        header
        echo "1. Create Student"
        echo "2. Edit Student"
        echo "3. Delete Student"
        echo "4. View Students"
        echo "5. Search Student by ID"
        echo "6. Search Student by Name"
        echo "7. View Statistics"
        echo "8. Sort Students"
        echo "9. Add Comment"
        echo "10. Backup Data"
        echo "11. Restore Data"
        echo "12. Exit"
        echo "Enter your choice:"
        read choice

        case $choice in
            1) create_student ;;
            2) edit_student ;;
            3) delete_student ;;
            4) view_students ;;
            5) search_student ;;
            6) search_student_by_name ;;
            7) view_statistics ;;
            8) sort_students ;;
            9) add_comment ;;
            10) backup_data ;;
            11) restore_data ;;
            12) exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

main_menu
