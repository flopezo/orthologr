#' @title Function to read a genome of a given organism
#' @description This function reads an organism specific genome stored in a defined file format.
#' @param file a character string specifying the path to the file storing the genome.
#' @param format a character string specifying the file format used to store the genome, e.g. "fasta", "gbk".
#' @param ... additional arguments that are used by the seqinr::read.fasta() function.
#' @author Hajk-Georg Drost and Sarah Scharfenberg
#' @details The \code{read.genome} function takes a string specifying the path to the genome file
#' of interest as first argument.
#'
#' It is possible to read in different genome file standards such as \emph{fasta} or \emph{genebank}.
#' Genomes stored in fasta files can be downloaded from http://ensemblgenomes.org/info/genomes.
#'
#' @examples \dontrun{
#' # reading a genome stored in a fasta file
#' Ath.genome <- read.genome(system.file('seqs/ortho_thal_cds.fasta', package = 'orthologr'),
#'                            format = "fasta")
#' }
#'
#' @return A data.table storing the gene id in the first column and the corresponding
#' sequence as string in the second column.
#' @export
read.genome <- function(file, format, ...){
        if(!is.element(format,c("fasta","gbk")))
                stop("Please choose a file format that is supported by this function.")
        
        if(format == "fasta"){
                genome <- vector(mode = "list")
                
                tryCatch(
                        {
                                 genome <- seqinr::read.fasta(file, seqtype = "DNA", ...)
                                 genome.dt <- data.table::data.table(geneids = names(genome),
                                                                     seqs = unlist(lapply(genome, seqinr::c2s)))
                                 data.table::setkey(genome.dt,geneids)
                                 
                        }, error = function(){ stop(paste0("File ",file, " could not be read properly. \n",
                        "Please make sure that ",file," contains only DNA sequences and is in ",format," format."))}
                )
        }
        return(genome.dt)
}


#' @title Function to read a proteome of a given organism
#' @description This function reads an organism specific proteome stored in a defined file format.
#' @param file a character string specifying the path to the file storing the proteome.
#' @param format a character string specifying the file format used to store the proteome, e.g. "fasta", "gbk".
#' @param ... additional arguments that are used by the seqinr::read.fasta() function.
#' @author Hajk-Georg Drost and Sarah Scharfenberg
#' @details The \code{read.proteome} function takes a string specifying the path to the proteome file
#' of interest as first argument.
#'
#' It is possible to read in different proteome file standards such as \emph{fasta} or \emph{genebank}.
#'
#' Proteomes stored in fasta files can be downloaded from http://www.ebi.ac.uk/reference_proteomes.
#'
#' @examples \dontrun{
#' # reading a proteome stored in a fasta file
#' Ath.proteome <- read.proteome(system.file('seqs/ortho_thal_aa.fasta', package = 'orthologr'),
#'                                format = "fasta")
#' }
#'
#' @return A data.table storing the gene id in the first column and the corresponding
#' sequence as string in the second column.
#' @export
read.proteome <- function(file, format, ...){
        if(!is.element(format,c("fasta","gbk")))
                stop("Please choose a file format that is supported by this function.")
        
        if(format == "fasta"){
                proteome <- vector(mode = "list")
                
                tryCatch(
                         {
                                 proteome <- seqinr::read.fasta(file, seqtype = "AA", ...)
                                 proteome.dt <- data.table::data.table(geneids = names(proteome),
                                                                       seqs = unlist(lapply(proteome, seqinr::c2s)))
                                 data.table::setkey(proteome.dt,geneids)
                                 
                         }, error = function(){ stop(paste0("File ",file, " could not be read properly. \n",
                                                             "Please make sure that ",file," contains only amino acid sequences and is in ",format," format."))}
                )
        }
        return(proteome.dt)
}


#' @title Function to read the CDS of a given organism
#' @description This function reads an organism specific CDS stored in a defined file format.
#' @param file a character string specifying the path to the file storing the CDS.
#' @param format a character string specifying the file format used to store the CDS, e.g. "fasta", "gbk".
#' @param ... additional arguments that are used by the seqinr::read.fasta() function.
#' @author Hajk-Georg Drost and Sarah Scharfenberg
#' @details The \code{read.cds} function takes a string specifying the path to the cds file
#' of interest as first argument.
#'
#' It is possible to read in different proteome file standards such as \emph{fasta} or \emph{genebank}.
#'
#' CDS stored in fasta files can be downloaded from http://www.ensembl.org/info/data/ftp/index.html.
#'
#' @examples \dontrun{
#' # reading a cds file stored in fasta format
#' Ath.cds <- read.cds(system.file('seqs/ortho_thal_cds.fasta', package = 'orthologr'),
#'                     format = "fasta")
#' }
#'
#' @return A data.table storing the gene id in the first column and the corresponding
#' sequence as string in the second column.
#' @export
read.cds <- function(file, format, ...){
        if(!is.element(format,c("fasta","gbk")))
                stop("Please choose a file format that is supported by this function.")
        
        if(format == "fasta"){
                cds <- vector(mode = "list")
                
                tryCatch(
                        {
                                cds <- seqinr::read.fasta(file, seqtype = "DNA", ...)
                                cds.dt <- data.table::data.table(geneids = names(cds),
                                                 seqs = unlist(lapply(cds, seqinr::c2s)))
                                data.table::setkey(cds.dt,geneids)
                
                        }, error = function(){ stop(paste0("File ",file, " could not be read properly. \n",
                                                            "Please make sure that ",file," contains only CDS sequences and is in ",format," format."))}
                )
        }
        return(cds.dt)
}



#' @title Function to translate an CDS sequence in string format to AA in string format
#' @description This function takes CDS sequence as string as input an returns the
#' corresponding amino acid sequence as string. 
#' @param sequence a character string specifying CDS sequence of interest.
#' @author Hajk-Georg Drost and Sarah Scharfenberg
#' @return A character string specifying the corresponding amino acid sequence.
transl <- function(sequence){
        return(seqinr::c2s(seqinr::translate(seqinr::s2c(sequence))))
}


test <- function(x){ print(paste0("Test ",x," passed.","\n"))}