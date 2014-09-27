#' @title Function to calculate the synonymous vs nonsynonymous substitutionrates for two organisms.
#' @description This function takes the CDS files of two organisms of interest (query_file and subject_file)
#' and computes the dNdS estimation values for orthologous gene pairs between these organisms. 
#' @param query_file a character string specifying the path to the CDS file of interest (query organism).
#' @param subject_file a character string specifying the path to the CDS file of interest (subject organism).
#' @param ortho_detection a character string specifying the orthology inference method that shall be performed
#' to detect orthologous genes. Default is \code{ortho_detection} = "RBH" (BLAST reciprocal best hit).
#' Further methods are: "BH" (BLAST best hit), "RBH" (BLAST reciprocal best hit), "PO" (ProteinOrtho), "OrthoMCL, "IP" (InParanoid).
#' @param blast_path a character string specifying the path to the BLAST program (in case you don't use the default path).
#' @param multialn_path a character string specifying the path to the multiple alignment program (in case you don't use the default path).
#' @param dnds_est.method a character string specifying the dNdS estimation method, e.g. "Comeron","Li" .
#' @param comp_cores a numeric value specifying the number of cores that shall be
#' @param tool a character string specifying the program that should be used e.g. "clustalw". 
#' @author Sarah Scharfenberg and Hajk-Georg Drost 
#' @details This function...
#' @return A data.table storing the dNdS values of the correspnding genes.
#' @examples \dontrun{
#' 
#' # get a dNdS table using:
#' # 1) reciprocal best hit for orthology inference (RBH)
#' # 2) clustalw for pairwise amino acid alignments
#' # 3) pal2nal for codon alignments
#' # 4) Yang, Z. and Nielsen, R. (2000) (YN) for dNdS estimation
#' # 5) single core processing 'comp_cores = 1'
#' dNdS(query_file = system.file('seqs/ortho_thal_cds.fasta', package = 'orthologr'),
#' subject_file = system.file('seqs/ortho_lyra_cds.fasta', package = 'orthologr'),
#' ortho_detection = "RBH",
#' multialn_tool = "clustalw", multialn_path = "/path/to/clustalw/",
#' codonaln_tool = "pal2nal", dnds_est.method = "YN", comp_cores = 1)
#' 
#' # The same result can be obtained using multicore processing using: comp_cores = 2 or 3 or more ...
#' dNdS(query_file = system.file('seqs/ortho_thal_cds.fasta', package = 'orthologr'),
#' subject_file = system.file('seqs/ortho_lyra_cds.fasta', package = 'orthologr'),
#' ortho_detection = "RBH",
#' multialn_tool = "clustalw", multialn_path = "/path/to/clustalw/",
#' codonaln_tool = "pal2nal", dnds_est.method = "YN", comp_cores = 2)
#' 
#' }
#' @import data.table
#' @export
dNdS <- function(query_file, subject_file, 
                 ortho_detection = "RBH", blast_path = NULL, 
                 multialn_tool = "clustalw", multialn_path = NULL,
                 multialn_params = NULL, codonaln_tool = "pal2nal", 
                 dnds_est.method = "YN", comp_cores = 1, quiet = FALSE){
        
        # determine the file seperator of the current OS
        f_sep <- .Platform$file.sep
        
        if(!is.element(ortho_detection, c("BH","RBH","PO","OrthoMCL","IP")))
                stop("Please choose a orthology detection method that is supported by this function.")
        
        if(!is.element(multialn_tool, c("clustalw", "clustalo","muscle", "t_coffee", "mafft")))
                stop("Please choose a multiple alignment tool that is supported by this function.")
        
        if(!is.element(codonaln_tool, c("pal2nal")))
                stop("Please choose a codon alignment tool that is supported by this function.")
        
        kaks_calc_methods <- c("MA","MS","NG","LWL","LPB","MLWL","YN","MYN","GY","kaks_calc")
        
        if(!is.element(dnds_est.method,c("Comeron","Li",kaks_calc_methods)))
                stop("Please choose a dNdS estimation method that is supported by this function.")
        
        # blast each translated aminoacid sequence against the related database to get a 
        # hit table with pairs of geneids  
        
  
        if(ortho_detection == "BH"){
                
                hit.table <- data.table::copy(
                        blast_best(query_file = query_file, subject_file = subject_file, 
                                   path = blast_path, comp_cores = comp_cores))
                                                
                q_cds <- read.cds(file = query_file, format = "fasta")
                s_cds <- read.cds(file = subject_file, format = "fasta")
                

                q_aa <- read.proteome(file = paste0("_blast",f_sep,"blastinput.fasta"), format = "fasta")
                
                filename <- unlist(strsplit(subject_file, f_sep, fixed = FALSE, perl = TRUE, useBytes = FALSE))
                filename <- filename[length(filename)]
                s_aa <- read.proteome(file = paste0("_database",f_sep,"out_",filename,"_translate.fasta"), format = "fasta")
    
        }
        
        if(ortho_detection == "RBH"){
                               
                hit.table <- data.table::copy(
                        blast_rec(query_file = query_file, subject_file = subject_file, 
                                   path = blast_path, comp_cores = comp_cores))
                
                q_cds <- read.cds(file = query_file, format = "fasta")
                s_cds <- read.cds(file = subject_file, format = "fasta")
                
                
                filename <- unlist(strsplit(query_file, f_sep, fixed = FALSE, perl = TRUE, useBytes = FALSE))
                filename <- filename[length(filename)]
                q_aa <- read.proteome(file = paste0("_database",f_sep,"out_",filename,"_translate.fasta"), format = "fasta")
                
                filename <- unlist(strsplit(subject_file, f_sep, fixed = FALSE, perl = TRUE, useBytes = FALSE))
                filename <- filename[length(filename)]
                s_aa <- read.proteome(file = paste0("_database",f_sep,"out_",filename,"_translate.fasta"), format = "fasta")
                
                
        }
    
        data.table::setnames(q_cds, old=c("geneids", "seqs"), new = c("query_id","query_cds"))
        data.table::setnames(s_cds, old=c("geneids", "seqs"), new = c("subject_id","subject_cds"))
        data.table::setnames(q_aa, old=c("geneids", "seqs"), new = c("query_id","query_aa"))
        data.table::setnames(s_aa, old=c("geneids", "seqs"), new = c("subject_id","subject_aa"))
        
        # joining all tables to a final table containing: query_id, subject_id, query_aa_seq, subject_aa_seq, query_cds_seq, and subject_cds_seq
        query_tbl <- dplyr::inner_join(dplyr::tbl_dt(q_cds), dplyr::tbl_dt(q_aa), by = "query_id")
        subject_tbl <- dplyr::inner_join(dplyr::tbl_dt(s_cds), dplyr::tbl_dt(s_aa), by = "subject_id")
        joint_query_tbl <- dplyr::inner_join(dplyr::tbl_dt(hit.table), dplyr::tbl_dt(query_tbl), by = "query_id")
        joint_subject_tbl <- dplyr::inner_join(dplyr::tbl_dt(hit.table), dplyr::tbl_dt(subject_tbl), by = "subject_id")
        final_tbl <- dplyr::inner_join(dplyr::tbl_dt(joint_query_tbl), dplyr::tbl_dt(joint_subject_tbl), by = c("query_id","subject_id"))
        
       # return the dNdS table for all query_ids and subject_ids
           return(compute_dnds(complete_tbl = final_tbl,
                       multialn_tool = multialn_tool,
                       multialn_path = multialn_path,
                       codonaln_tool = codonaln_tool, 
                       dnds_est.method = dnds_est.method, quiet = quiet,
                       comp_cores = comp_cores)
                       )   
}




#' @title Function to calculate the synonymous vs nonsynonymous substitutionrate for a codon alignment.
#' @description This function takes a pairwise alignment as input file and estimates the
#' dNdS ratio of the corresponding alignment. Nevertheless, this function is a helper function for
#' \code{\link{dNdS}}. For dNdS computations you should use the function: \code{\link{dNdS}}.
#' @param file a character string specifying the path to a codon alignment file
#' @param est.method a character string specifying the dNdS estimation method, e.g. "Comeron","Li" .
#' Note, that when using "Comeron" as dNdS estimation method, the program 'gestimator' is used to compute the
#' corresponding dNdS values from a given alignment. The program 'gestimator' can only read "fasta" files,
#' hence it is important to use format = "fasta" when choosing est.method = "Comeron".
#' @param format a character string specifying the file format in which the alignment is stored:  
#' "mase", "clustal", "phylip", "fasta" , "msf"
#' @param quiet a logical value specifying whether the output of the coresponding interface shall be printed out.
#' @param kaks_calc.params a character string storing additional parameters for KaKs_Claculator 1.2 . Default is \code{NULL}. Example:
#' \code{kaks_calc.params} = "-m NG -m YN". 
#' @author Hajk-Georg Drost and Sarah Scharfenberg
#' @details This function takes a pairwise alignments file as input and estimates dNdS ratios
#' of the corresponding alignments using predefined dNdS estimation methods.
#' 
#' The dNdS estimation methods available in this function are:
#' 
#' - "Li" : Li's method (1993) -> provided by the ape package
#' 
#' - "Comeron" : Comeron's method (1995)
#' 
#' dNdS estimation methods provided by KaKs_Calculator 1.2 :
#' 
#' Approximate Methods:
#' 
#' "NG": Nei, M. and Gojobori, T. (1986)
#' 
#' "LWL": Li, W.H., et al. (1985)
#' 
#' "LPB": Li, W.H. (1993) and Pamilo, P. and Bianchi, N.O. (1993)
#' 
#' "MLWL" (Modified LWL), MLPB (Modified LPB): Tzeng, Y.H., et al. (2004)
#' 
#' "YN": Yang, Z. and Nielsen, R. (2000)
#' 
#' "MYN" (Modified YN): Zhang, Z., et al. (2006)
#' 
#' Maximum-Likelihood Methods:
#' 
#' GY: Goldman, N. and Yang, Z. (1994)
#' 
#' MS (Model Selection), MA (Model Averaging): based on a set of candidate models defined by Posada, D. (2003) as follows.
#' 
#' MS (Model Selection) and MA (Model Averaging) over:
#' 
#' JC,
#' F81,
#' K2P, 
#' HKY,
#' TrNEF,
#' TrN,
#' K3P,
#' K3PUF,
#' TIMEF,
#' TIM,
#' TVMEF,
#' TVM,
#' SYM,
#' GTR
#' 
#' @examples \dontrun{
#' 
#' # estimate the dNdS rate using Li's method
#' substitutionrate(system.file("seqs/aa_seqs.aln", package = "orthologr"),
#'                  est.method = "Li", format = "clustal")
#'  
#'  # estimate the dNdS rate using model averaging provided by the KaKs_Calculator 1.2 program
#'  substitutionrate(system.file("seqs/pal2nal.aln", package = "orthologr"), 
#'                   est.method = "MA", format = "fasta") 
#'                   
#'  # estimate the dNdS rate using Nei and Gojobori's method provided by the KaKs_Calculator 1.2 program
#'  substitutionrate(system.file("seqs/pal2nal.aln", package = "orthologr"), 
#'                   est.method = "NG", format = "fasta")     
#'   
#'   # estimate the dNdS rate using Nei and Gojobori's method AND Yang and Nielsen's method provided by the KaKs_Calculator 1.2 program 
#'   # for this purpose we choose: est.method = "kaks_calc" and kaks_calc.params = "-m NG -m YN"                 
#'  substitutionrate(system.file("seqs/pal2nal.aln", package = "orthologr"),
#'                   est.method = "kaks_calc", format = "fasta",kaks_calc.params = "-m NG -m YN")            
#' }
#' @references 
#' Li, W.-H. (1993) Unbiased estimation of the rates of synonymous and nonsynonymous substitution. J. Mol. Evol., 36:96-99.
#' 
#' Charif, D. and Lobry, J.R. (2007) SeqinR 1.0-2: a contributed package to the R project for statistical computing devoted to biological sequences retrieval and analysis.
#' 
#' Thornton, K. (2003) libsequence: a C++ class library for evolutionary genetic analysis. Bioinformatics 19(17): 2325-2327
#' 
#' Zhang Z, Li J, Zhao XQ, Wang J, Wong GK, Yu J: KaKs Calculator:
#' Calculating Ka and Ks through model selection and model averaging. Genomics Proteomics Bioinformatics 2006 , 4:259-263.
#' 
#' https://code.google.com/p/kaks-calculator/wiki/KaKs_Calculator
#' 
#' https://code.google.com/p/kaks-calculator/wiki/AXT
#' 
#' @return A data.table storing the query_id, subject_id, dN, dS, and dNdS values or 
#' a data.table storing the query_id, method, dN, dS, and dNdS values when using KaKs_Calculator.
#' @import data.table
#' @export
substitutionrate <- function(file, est.method, format = "fasta", quiet = FALSE, kaks_calc.params = NULL){
        
        
        # dNdS estimation methods provided by the KaKs_Calculator 1.2 program
        kaks_calc_methods <- c("MA","MS","NG","LWL","LPB","MLWL","YN","MYN","GY","kaks_calc")
        
        if(!is.element(est.method,c("Comeron","Li",kaks_calc_methods)))
                stop("Please choose a dNdS estimation method that is supported by this function.")
        
        if(!is.element(format,c("mase", "clustal", "phylip", "fasta" , "msf" )))
                stop("Please choose a format that is supported by seqinr::read.alignment.")
        
        # determine the file seperator of the current OS
        f_sep <- .Platform$file.sep
        
        if(!file.exists(paste0("_calculation",f_sep))){
                
                dir.create("_calculation")
        }
        
        
        if(est.method == "Comeron"){
               
           # file in fasta required     
           if(format != "fasta")
                   stop("To use gestimator an alignment file in fasta format is required.")
           
            tryCatch(
            {    
                # To use gestimator a file in fasta format is required    
                system(paste0("gestimator -i ",file," -o ","_calculation",f_sep,"gestimout"))
                
                hit.table <-data.table::fread(paste0("_calculation",f_sep,"gestimout"))
                data.table::setnames(hit.table, old=c("V1","V2","V3","V4","V5"), 
                                     new = c("query_id","subject_id","dN","dS","dNdS"))
                data.table::setkey(hit.table, query_id)
                
                if(!quiet){print("Substitutionrate successfully calculated by gestimator")}
                
                return(hit.table)
            },error = function(){ stop(paste0("Please check the correct path to ",est.method,
                                               "... the interface call did not work properly.") ) }
            
            )
        }
        
        if(est.method == "Li" ){
                
                        aln <- seqinr::read.alignment(file = file, format = format)
                
                        res_list <- seqinr::kaks(aln)
                        
                        res <- data.table::data.table(t(c(unlist(aln$nam),  res_list$ka, res_list$ks, (res_list$ka/res_list$ks))))
                        data.table::setnames(res, old = paste0("V",1:5), 
                                             new = c("query_id","subject_id", "dN", "dS","dNdS"))
                        data.table::setkey(res,query_id)
                 
                        if(!quiet){print("Substitutionrate successfully calculated using Li's method.")}
                        
                        return(res)
                        
        
        }
        
        if(is.element(est.method,kaks_calc_methods)){
                
                
                operating_sys <- Sys.info()[1]
                
                if (operating_sys == "Darwin"){ 
                        os <- "Mac"
                        calc <- "KaKs_Calculator"
                }
                
                if (operating_sys == "Linux"){
                        os <- "Linux"
                        calc <- "KaKs_Calculator"
                }
                
                if (operating_sys == "Windows"){ 
                        os <- "Windows"
                        calc <- "KaKs_Calculator.exe"
                }
                
               # determine the file seperator of the current OS
               f_sep <- .Platform$file.sep
               fa2axt <- system.file(paste0("KaKs_Calculator1.2",f_sep,"parseFastaIntoAXT.pl"), package = "orthologr")
               
               file_name <- unlist(strsplit(file,f_sep))
               file_name <- file_name[length(file_name)]
               curr_wd <- unlist(strsplit(getwd(),f_sep))
               wdir <- grepl(" ",curr_wd)
               
               curr_wd[wdir] <- stringr::str_replace(string = curr_wd[wdir],replacement = paste0("'",curr_wd[wdir],"'"), pattern = curr_wd[wdir])
               
               curr_wd <- paste0(curr_wd,collapse = f_sep)
               
               tryCatch(
                       
              {
                       system(paste0("perl ",fa2axt ," ",file," ",curr_wd,f_sep,"_calculation",f_sep,file_name))
                       KaKs_Calculator <- system.file(paste0("KaKs_Calculator1.2",f_sep,"bin",f_sep,os,f_sep,calc), package = "orthologr")
               
                       if(is.null(kaks_calc.params))
                               system(paste0(KaKs_Calculator," -i ",paste0("_calculation",f_sep,file_name,".axt")," -o ",paste0("_calculation",f_sep,file_name,".axt.kaks"," -m ",est.method)))
               
                       if(!is.null(kaks_calc.params))
                               system(paste0(KaKs_Calculator," -i ",paste0("_calculation",f_sep,file_name,".axt")," -o ",paste0("_calculation",f_sep,file_name,".axt.kaks ",kaks_calc.params)))
               
              },error = function(){ stop(paste0("KaKs_Calculator 1.2 couln't run properly, please check your input files."))}
               
              )
              
              tryCatch(
                      {
                              kaks_tbl <- read.csv(paste0("_calculation",f_sep,file_name,".axt.kaks"),sep = "\t", header = TRUE)
                              kaks_tbl_res <- kaks_tbl[ , 1:5]
                              kaks_tbl_res <- data.frame(sapply(kaks_tbl_res[ , 1], function(x) unlist(strsplit(as.character(x),"-"))[1]),
                                                         sapply(kaks_tbl_res[ , 1], function(x) unlist(strsplit(as.character(x),"-"))[2]) ,
                                                         kaks_tbl_res[ , c(3:5,2)])
              
                              names(kaks_tbl_res) <- c("query_id","subject_id", "dN", "dS","dNdS","method")
                              kaks_tbl_res <- data.table::as.data.table(kaks_tbl_res)
                              data.table::setkey(kaks_tbl_res,query_id)
               
                              return(kaks_tbl_res)
                              
                      }, error = function(){stop(paste0("Something went wront with KaKs_Calculator .\n",
                                                         paste0("_calculation",f_sep,file_name,".axt.kaks"),
                                                         " could not be read properly."))}
              )
        }
        
}



#' @title This function computes the dNdS value of one given pairwise alignment.
#' @description This function takes a vector containing the query_id, subject_id,
#' query amino acid sequence, subject amino acid sequence, query CDS sequence, and subject CDS sequence
#' and then runs the following pipieline:
#' 
#' 1) Multiple-Alignment of query amino acid sequence and subject amino acid sequence
#' 
#' 2) Codon-Alignment of the amino acid alignment returned by 1) and query CDS sequence + subject CDS sequence
#' 
#' 3) dNdS estimation of the codon alignment returned by 2)
#' 
#' @param complete_tbl
#' @param multialn_tool
#' @param multialn_path
#' @param multialn_params
#' @param codonaln_tool
#' @param dnds_est.method
#' @param quiet
#' @param comp_cores
#' @author Sarah Scharfenberg and Hajk-Georg Drost
#' @details This function takes the amino acid and CDS sequences two orthologous genes
#' and writes the corresponding amino acid and CDS sequences as fasta file into
#' the internal folder environment. The resulting fasta files (two files) store the 
#' amino acid sequence of the query_id and subject_id (file one) and the CDS sequence of
#' the query_id and subject_id (file two). These fasta files are then used to pass through the following pipeline:
#' 
#' 1) Multiple-Alignment of query amino acid sequence and subject amino acid sequence
#' 
#' 2) Codon-Alignment of the amino acid alignment returned by 1) and query CDS sequence + subject CDS sequence
#' 
#' 3) dNdS estimation of the codon alignment returned by 2)
#' 
#' @import foreach
#' @export
compute_dnds <- function(complete_tbl,
                         multialn_tool = "clustalw", multialn_path = NULL,
                         multialn_params = NULL, codonaln_tool = "pal2nal",
                         dnds_est.method = "YN", quiet = FALSE, comp_cores = 1){
        
        multicore <- (comp_cores > 1)
        
        print(paste0("MULTICORE: ",multicore))
        
        # determine the file seperator of the current OS
        f_sep <- .Platform$file.sep
        
        orthologs_names <- vector(mode = "list", length = 2)
        cds_seqs <- vector(mode = "list", length = 2)
        aa_seqs <- vector(mode = "list", length = 2)
        cds_session_fasta <- vector(mode = "character", length = 1)
        aa_session_fasta <- vector(mode = "character", length = 1)
        pairwise_aln_name <- vector(mode = "character", length = 1)
        
        if(!multicore)
                dNdS_values <- vector(mode = "list", length = ncol(complete_tbl))
        
        
        
        if(!file.exists(paste0("_alignment",f_sep,"orthologs",f_sep))){
                
                dir.create(paste0("_alignment",f_sep,"orthologs"))
        }
        
        if(!file.exists(paste0("_alignment",f_sep,"orthologs",f_sep,"CDS",f_sep))){
                
                dir.create(paste0("_alignment",f_sep,"orthologs",f_sep,"CDS"))
        }
        
        if(!file.exists(paste0("_alignment",f_sep,"orthologs",f_sep,"AA",f_sep))){
                
                dir.create(paste0("_alignment",f_sep,"orthologs",f_sep,"AA"))
        }
        
        if(comp_cores > parallel::detectCores())
                stop("You assigned more cores to the comp_cores argument than are availible on your machine.")
        
        if(multicore){
                ### Parallellizing the sampling process using the 'doMC' and 'parallel' package
                ### register all given cores for parallelization
                ### detectCores(all.tests = TRUE, logical = FALSE) returns the number of cores available on a multi-core machine
                cores <- parallel::makeForkCluster(comp_cores)
                doParallel::registerDoParallel(cores)
        } 
                
        if(!multicore){        
              for(i in 1:ncol(complete_tbl)){
                  dNdS_values[i] <- list((function(i) {
                
          ### Perform the sampling process in parallel
#         dNdS_values <- foreach::foreach(i = 1:ncol(complete_tbl),.combine="rbind") %dopar%{
                
                # storing the query gene id and subject gene id of the orthologous gene pair 
                orthologs_names <- list(complete_tbl[i , query_id],complete_tbl[i, subject_id])
        
                # storing the query CDS sequence and subject CDS sequence of the orthologous gene pair 
                cds_seqs <- list(complete_tbl[i, query_cds],complete_tbl[i, subject_cds])
        
                # storing the query amino acid sequence and subject amino acid sequence of the orthologous gene pair 
                aa_seqs <- list(complete_tbl[i, query_aa],complete_tbl[i, subject_aa])
        
        
                #pairwise_aln_name <- paste0("query_",i,"___","subject_",i)
                pairwise_aln_name <- paste0("q",i)

                # create cds fasta of orthologous gene pair having session name: 'pairwise_aln_name'
                cds_session_fasta <- paste0("_alignment",f_sep,"orthologs",f_sep,"CDS",f_sep,pairwise_aln_name,"_cds.fasta")
                seqinr::write.fasta(sequences = cds_seqs, names = orthologs_names, file.out = cds_session_fasta)
        
                # create aa fasta of orthologous gene pair having session name: 'pairwise_aln_name'
                aa_session_fasta <- paste0("_alignment",f_sep,"orthologs",f_sep,"AA",f_sep,pairwise_aln_name,"_aa.fasta")
                seqinr::write.fasta(sequences = aa_seqs, names = orthologs_names, file.out = aa_session_fasta)
        
                # which multi_aln tool should get the parameters
                #multi_aln_tool_params <- paste0(multialn_tool,".",params)
                             
#                 pairwise_aln <- Biostrings::pairwiseAlignment(aa_seqs[[1]],aa_seqs[[2]], type = "global")
#                 
#                 Biostrings::writePairwiseAlignments(pairwise_aln, block.width = 60)
#                 
                

                # align aa -> <multialn_tool>.aln
                multi_aln(file = aa_session_fasta, 
                          tool = multialn_tool, get_aln = FALSE, 
                          multi_aln_name = pairwise_aln_name, 
                          path = multialn_path, quiet = quiet)

                multi_aln_session_name <- paste0(pairwise_aln_name,"_",multialn_tool,".aln")
                
                
                # align codon -> cds.aln
                codon_aln(file_aln = paste0("_alignment",f_sep,"multi_aln",f_sep,multi_aln_session_name),
                          file_nuc = cds_session_fasta, tool = codonaln_tool,format = "fasta",
                          codon_aln_name = pairwise_aln_name,
                          get_aln = FALSE, quiet = quiet)
        
                codon_aln_session_name <- paste0(pairwise_aln_name,"_",codonaln_tool,".aln")
                
                
                
                # compute kaks
                dNdS.table <- substitutionrate(file = paste0("_alignment",f_sep,"codon_aln",f_sep,codon_aln_session_name), 
                                               est.method = dnds_est.method, quiet = quiet)
                
                return(dNdS.table)
        
                })(i)
              )
            }
        }

        if(multicore){
        
                ### Perform the sampling process in parallel
                dNdS_values <- foreach::foreach(i = 1:ncol(complete_tbl),.combine="rbind") %dopar%{
                
                # storing the query gene id and subject gene id of the orthologous gene pair 
                orthologs_names <- list(complete_tbl[i , query_id],complete_tbl[i, subject_id])
                
                # storing the query CDS sequence and subject CDS sequence of the orthologous gene pair 
                cds_seqs <- list(complete_tbl[i, query_cds],complete_tbl[i, subject_cds])
                
                # storing the query amino acid sequence and subject amino acid sequence of the orthologous gene pair 
                aa_seqs <- list(complete_tbl[i, query_aa],complete_tbl[i, subject_aa])
                
                
                #pairwise_aln_name <- paste0("query_",i,"___","subject_",i)
                pairwise_aln_name <- paste0("q",i)
                
                # create cds fasta of orthologous gene pair having session name: 'pairwise_aln_name'
                cds_session_fasta <- paste0("_alignment",f_sep,"orthologs",f_sep,"CDS",f_sep,pairwise_aln_name,"_cds.fasta")
                seqinr::write.fasta(sequences = cds_seqs, names = orthologs_names, file.out = cds_session_fasta)
                
                # create aa fasta of orthologous gene pair having session name: 'pairwise_aln_name'
                aa_session_fasta <- paste0("_alignment",f_sep,"orthologs",f_sep,"AA",f_sep,pairwise_aln_name,"_aa.fasta")
                seqinr::write.fasta(sequences = aa_seqs, names = orthologs_names, file.out = aa_session_fasta)
                
                # which multi_aln tool should get the parameters
                #multi_aln_tool_params <- paste0(multialn_tool,".",params)
                
                #                 pairwise_aln <- Biostrings::pairwiseAlignment(aa_seqs[[1]],aa_seqs[[2]], type = "global")
                #                 
                #                 Biostrings::writePairwiseAlignments(pairwise_aln, block.width = 60)
                #                 
                
                
                # align aa -> <multialn_tool>.aln
                multi_aln(file = aa_session_fasta, 
                          tool = multialn_tool, get_aln = FALSE, 
                          multi_aln_name = pairwise_aln_name, 
                          path = multialn_path, quiet = quiet)
                
                multi_aln_session_name <- paste0(pairwise_aln_name,"_",multialn_tool,".aln")
                
                
                # align codon -> cds.aln
                codon_aln(file_aln = paste0("_alignment",f_sep,"multi_aln",f_sep,multi_aln_session_name),
                          file_nuc = cds_session_fasta, tool = codonaln_tool,format = "fasta",
                          codon_aln_name = pairwise_aln_name,
                          get_aln = FALSE, quiet = quiet)
                
                codon_aln_session_name <- paste0(pairwise_aln_name,"_",codonaln_tool,".aln")
                
                
                
                # compute kaks
                dNdS.table <- substitutionrate(file = paste0("_alignment",f_sep,"codon_aln",f_sep,codon_aln_session_name), 
                                               est.method = dnds_est.method, quiet = quiet)
                
                return(dNdS.table)
                
        }
                ### close the cluster connection
                ### The is important to be able to re-run the function N times
                ### without getting cluster connection problems
                parallel::stopCluster(cores)
        
        }


        if(!multicore)
                dNdS_tbl <- data.table::as.data.table(do.call(rbind,dNdS_values))

        if(multicore)
        dNdS_tbl <- data.table::as.data.table(dNdS_values)

        setkeyv(dNdS_tbl,c("query_id","subject_id"))

        return(dNdS_tbl)

}





