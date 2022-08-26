<!-- This is README.md for BLAST Suite of Tools -->
# BLAST: Basic Local Alignment Search Tool

BLAST is a representation of both an algorithm and a suite of tools that implement local alignments. BLAST Tool allows us to search a collection of target sequences for alignments that match a query sequence. As the name suggests, the results of a BLAST search are local alignments, thus a BLAST result is generally a partial match of the query sequence to a target sequence in the database.

BLAST can be run both as a web interface from NCBI website and can be setup from BLAST standlone downloadable tool. The BLAST suite of tools encompass blastn, blastp, blastx, tblastn, tblastx and others.

### Note:
- A search may occur in nucleotide space, protein space or translated spaces where nucleotides are translated into proteins.
- Searches may implement search “strategies”: optimizations to a specific task. Different search strategies will produce different alignments. (Meaning different search algorithms)


We basically can fire-up the BLAST queries on *query sequence(s)* in 2 ways;
1. [Online BLAST](Online-BLAST.pdf)
2. Local BLAST

------------

### Online BLAST
Reference: [BLAST suite](https://blast.ncbi.nlm.nih.gov/Blast.cgi) of tools


------------

### Local BLAST
Here are the steps to setup a Local BLAST Database.

#### Prerequisites
- Check if the python available is Version 3 or later `python --version`
- Install [bio](https://www.bioinfo.help/) package -- `pip install bio`
- Install [e-utils](https://www.ncbi.nlm.nih.gov/books/NBK179288/). Run the following commands:
  ```
  sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
  export PATH=${PATH}:${HOME}/edirect
  ```
- Install bioconda and seqkit -- `conda install -c bioconda seqkit` or  `apt install seqkit`
- Install ncbi-blast
  ```
  sudo apt install acedb-other ncbi-entrez-direct
  sudo apt install ncbi-blast+ ncbi-entrez-direct ncbi-blast+-legacy
  ```
  

#### Steps to build a Local BLAST Database
1. Prepare a BLAST database with **makeblastdb**. This task only needs to be done once per sequence data.
2. Select the appropriate **BLAST tool**: blastn, blastp, etc. Depending on your needs you may need to tune the parameters.
3. Run the BLAST tool and format the output as necessary.

#### Building a Local BLAST Database
1. Fetch the Accession Number from UK BioBank or other websites.
2. The Accession Number of the amino acid or nucleotides sequence is used to fetch the sequences from GenBank using `bio` package.
   > Hemoglobin beta subunit [Homo sapiens] -- bio search NP_000509
   
   > Hemoglobin alpha subunit [Homo sapiens] -- bio search NP_000508
   
   *NP_000508* and *NP_000509* are the accession numbers of alpha and beta hemoglobin subunit protein in humans.
3. Now we can fetch the data using `bio fetch <Accession Number>` and append it to a file.
   ```
   bio fetch NP_000508 --format fasta > NP_000508.fa
   ```
   OR
   ```
   bio fetch NP_000508 > alpha.gb
   cat alpha.gb | bio table -type CDS -fields id,gene,size
   bio fetch CDS-1 --format fasta > alpha.fa
   ```
4. Using the fasta file we will build a Local BLAST DB.
   ```
   makeblastdb 
      -dbtype prot 
      -in NP_000508.fa 
      -out $HOME/BLAST_Testing/hemoglobin_alpha_subunit
   ```
   - `makeblastdb` command is used to build the Local BLAST DB
   - `-dbtype` we can either enter `nucl` or `prot` based on if we are having nucleotide or peptide sequence in the fasta file which we fetched from GenBank.
   - `-in` input sequence or a fasta file 
   - `-out` directory where the Local BLAST DB should be saved
5. Search the *query sequence* against the Local BLAST DB created in the previous step. 
   Based on the *query sequence* we can run different BLAST programs as mentioned below;
   - `blastp -db /home/acog/BLAST_Testing/hemoglobin_alpha_subunit -query test.fa | less`
   - `blastn -db /home/acog/BLAST_Testing/hemoglobin_alpha_subunit -query test.fa | less`
   - `blastx -db /home/acog/BLAST_Testing/hemoglobin_alpha_subunit -query test.fa | less`

---------
# How to use the blast.sh script
- ## Prerequisites
     - Python version 3 (OR) later -- `python --version`
     - To install [bio](https://www.bioinfo.help/) package -- `pip install bio`
     - To install ncbi-blast -- `sudo apt install ncbi-blast+`
  
- ## To run the blast.sh
     `./blast.sh`
     - The shell script will prompt the user for the parameters to be displayed in the report, threshold of sequence match, etc.
     - The shell script will build the Local BLAST DB and then perform a search by taking the `.fa file path` as a user input.
     > Note: To run the blast.sh, modify the Local BLAST Database location in the shell script accordingly.

- ## Further References 
     - Biostar Handbook (4 Units of BLAST)
     - [NCBI QuickStart Guide](https://www.ncbi.nlm.nih.gov/books/NBK1734/#:~:text=There%20are%20three%20varieties%20of,sequences%20in%20a%20nucleotide%20database)
     - [Magic-Blast](https://ncbi.github.io/magicblast/)
     - [Blast-FASTA](https://www.cs.rice.edu/~ogilvie/comp571/2018/09/04/blast-fasta.html)
     - [Command line BLAST](https://open.oregonstate.education/computationalbiology/chapter/command-line-blast/)
