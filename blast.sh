#!/bin/bash

set -e

# Variables
sleep_var=1
default_col_var="6 qseqid sseqid qstart qend sstart send evalue score pident"
output_var="6"


#######################################
echo "######################################################################################################"
echo "######################################################################################################"
echo "                                "
echo "                                "
echo "######################################################################################################"
echo "##################################### Local BLAST DB Script ##########################################"
echo "######################################################################################################"
echo "                                "
echo "                                "
echo "######################################################################################################"
echo "######################################################################################################"
#######################################


echo " "
read -p "Enter the Accession Number of the Nucl (OR) Prot sequence: ==> " accession_number
echo " "


############ MAKE BLAST DB ############


echo -n "Here is the data related to the given $accession_number and Title -- `bio search $accession_number | grep -i 'title' | awk -F':' '{print$2}' | awk -F',' '{print$1}'`"
echo " "

bio search $accession_number

echo " "

# if set -e is enabled this loop is void
if [[ $? -eq 1 ]]
then
	echo "Error: Accession Number - $accession_number provided does not exist in the GenBank Database"
	exit
fi

bio fetch $accession_number --format fasta > $accession_number.fa

echo " "
echo " "
echo "Local BLAST Database Type :"
echo " "
echo "1. nucl"
echo "2. prot"

echo " "
read -p "Select the Local BLAST Database Type to build: ==> " database_type
echo " "
read -p  "Enter the file path where the BLAST DB should be built: ==> " out_path
echo " "

sleep 1

# Selecting specific BLAST DB to fire the qurey seq's
if [[ $database_type -eq 1 ]]
then
	makeblastdb -dbtype nucl -in $accession_number.fa -out $out_path
        echo "The Local BLAST DB is created: `makeblastdb -dbtype nucl -in $accession_number.fa -out $out_path | grep -i 'new db name'`"
elif [[ $database_type -eq 2 ]]
then
	makeblastdb -dbtype prot -in $accession_number.fa -out $out_path
        echo "The Local BLAST DB is created: `makeblastdb -dbtype prot -in $accession_number.fa -out $out_path | grep -i 'new db name'`"
fi

sleep 2

echo " "
echo " "

#######################################


echo "######################################################################################################"
echo "                                                      "
echo "Input all the format specifiers to be included in the results.csv:"
echo "                                                      "
echo "These are some of the supported format specifiers, "
echo "if need be please check further by using < blastp -help >"
echo "                                                      "

echo "              qseqid means Query Seq-id"
echo "                 qgi means Query GI"
echo "                qacc means Query accesion"
echo "                qlen means Query sequence length"
echo "              sseqid means Subject Seq-id"
echo "                slen means Subject sequence length"
echo "              qstart means Start of alignment in query"
echo "                qend means End of alignment in query"
echo "              sstart means Start of alignment in subject"
echo "                send means End of alignment in subject"
echo "                qseq means Aligned part of query sequence"
echo "                sseq means Aligned part of subject sequence"
echo "              evalue means Expect value"
echo "               score means Raw score"
echo "              length means Alignment length"
echo "              pident means Percentage of identical matches"
echo "                gaps means Total number of gaps"
echo "                ppos means Percentage of positive-scoring matches"
echo "                                                      "
echo "Here are the default input fields, ENTER to proceed ==> 'qseqid sseqid qstart qend sstart send evalue score pident'"
echo "  OR"
echo "Enter manually for specific format specifiers mentioned above ..."
echo "Example: qseqid sseqid score"
echo "NOTE: DO NOT mention 'pident' in the input, it will be appened in the last column by default."

read -p "Enter the columns in the output -- results.csv: ==> " col_var

temp_var=`echo $col_var | wc -c`

echo "                                                      "
echo "                                                      "

read -p "Provide the fasta sequence location(.fa file) or a query sequence to search against the BLAST DB ==> " query_sequence

echo "Select threshold value for the Local BLAST search:"
echo "NOTE: Default threshold value: 90, to continue press 'Enter'"
echo "                                                      "
echo "1. 50"
echo "2. 80"
echo "3. 85"
echo "4. 90"
echo "5. 95"
echo "6. 100"
echo "                                                      "
read -p "Enter the threshold for the query & subject 'sequence match percentage' to filter the data ==> " threshold
echo "                                "

echo "Enter the type of BLAST search:"
echo "1. blastn"
echo "2. blastp"
echo "3. blastx"
echo "4. tblastn"
echo "                                "
read -p "Local BLAST DB Search ==> " db_search

if [[ $temp_var -gt 1 ]]
then
        if [[ $db_search -eq 1 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastn -db $out_path -query $query_sequence -outfmt $col_var > $HOME/results.csv"
                blastn -db $out_path -query $query_sequence -outfmt "$output_var $col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 2 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastp -db $out_path -query $query_sequence -outfmt $col_var > $HOME/results.csv"
                blastp -db $out_path -query $query_sequence -outfmt "$output_var $col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 3 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastx -db $out_path -query $query_sequence -outfmt $col_var > $HOME/results.csv"
                blastx -db $out_path -query $query_sequence -outfmt "$output_var $col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 4 ]]
        then
                echo "                                                      "
                echo "Running the query >>> tblastn -db $out_path -query $query_sequence -outfmt $col_var > $HOME/results.csv"
                tblastn -db $out_path -query $query_sequence -outfmt "$output_var $col_var pident"  > $HOME/results.csv
                echo "                                                      "
        else
                echo "Incorrect Local BLAST DB Search arg."
                exit
        fi
else
        if [[ $db_search -eq 1 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastn -db $out_path -query $query_sequence -outfmt $default_col_var > $HOME/results.csv"
                blastn -db $out_path -query $query_sequence -outfmt "$output_var $default_col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 2 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastp -db $out_path -query $query_sequence -outfmt $default_col_var > $HOME/results.csv"
                blastp -db $out_path -query $query_sequence -outfmt "$output_var $default_col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 3 ]]
        then
                echo "                                                      "
                echo "Running the query >>> blastx -db $out_path -query $query_sequence -outfmt $default_col_var > $HOME/results.csv"
                blastx -db $out_path -query $query_sequence -outfmt "$output_var $default_col_var pident"  > $HOME/results.csv
                echo "                                                      "

        elif [[ $db_search -eq 4 ]]
        then
                echo "                                                      "
                echo "Running the query >>> tblastn -db $out_path -query $query_sequence -outfmt $default_col_var > $HOME/results.csv"
                tblastn -db $out_path -query $query_sequence -outfmt "$output_var $default_col_var pident"  > $HOME/results.csv
                echo "                                                      "
        else
                echo "Incorrect Local BLAST DB Search arg."
                exit
        fi
fi


echo "                                "
echo "######################################################################################################"
echo "############################################# RESULTS ################################################"
echo "######################################################################################################"
echo "                                "
echo "                                                      "
chmod 700 $HOME/results.csv
echo "There are around `less $HOME/results.csv | wc -l` sequence matches"
echo "                                                      "

echo "Filtering the results based on the threshold selected."

# Selecting threshold for Local BLAST search -- awk '{ if ($NF>80) print $0}'
if [[ $threshold -eq 1 ]]
then
	less $HOME/results.csv | awk '{if ($NF > 50 ) print $0}' >> $HOME/results.csv
elif [[ $threshold -eq 2 ]]
then
	less $HOME/results.csv | awk '{if ($NF > 80 ) print $0}' >> $HOME/results.csv
elif [[ $threshold -eq 3 ]]
then
	less $HOME/results.csv | awk '{if ($NF > 85 ) print $0}' >> $HOME/results.csv
elif [[ $threshold -eq 4 ]]
then
	less $HOME/results.csv | awk '{if ($NF > 90 ) print $0}' >> $HOME/results.csv
elif [[ $threshold -eq 5 ]]
then
	less $HOME/results.csv | awk '{if ($NF > 95 ) print $0}' >> $HOME/results.csv
elif [[ $threshold -eq 6 ]]
then	less $HOME/results.csv | awk '{if ($NF > 100 ) print $0}' >> $HOME/results.csv
else
     less $HOME/results.csv | awk '{if ($NF > 90 ) print $0}' >> $HOME/results.csv
fi

echo "Here are the results generated for the query sequence $query_sequence against $out_path ==> $HOME/results.csv"
echo "Results opening in 4 seconds ..."
sleep 4
less $HOME/results.csv

echo "######################################################################################################"




exit
