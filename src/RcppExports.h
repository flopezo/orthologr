// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// Different
bool Different(const string& seq1, const string& seq2, bool skip_missing = false, bool nucleic_acid = false);
RcppExport SEXP orthologr_Different(SEXP seq1SEXP, SEXP seq2SEXP, SEXP skip_missingSEXP, SEXP nucleic_acidSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< const string& >::type seq1(seq1SEXP );
        Rcpp::traits::input_parameter< const string& >::type seq2(seq2SEXP );
        Rcpp::traits::input_parameter< bool >::type skip_missing(skip_missingSEXP );
        Rcpp::traits::input_parameter< bool >::type nucleic_acid(nucleic_acidSEXP );
        bool __result = Different(seq1, seq2, skip_missing, nucleic_acid);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// NumDiffs
unsigned NumDiffs(const string& seq1, const string& seq2, bool skip_missing = false, bool nucleic_acid = false);
RcppExport SEXP orthologr_NumDiffs(SEXP seq1SEXP, SEXP seq2SEXP, SEXP skip_missingSEXP, SEXP nucleic_acidSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< const string& >::type seq1(seq1SEXP );
        Rcpp::traits::input_parameter< const string& >::type seq2(seq2SEXP );
        Rcpp::traits::input_parameter< bool >::type skip_missing(skip_missingSEXP );
        Rcpp::traits::input_parameter< bool >::type nucleic_acid(nucleic_acidSEXP );
        unsigned __result = NumDiffs(seq1, seq2, skip_missing, nucleic_acid);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// TsTv
string TsTv(int i, int j);
RcppExport SEXP orthologr_TsTv(SEXP iSEXP, SEXP jSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< int >::type i(iSEXP );
        Rcpp::traits::input_parameter< int >::type j(jSEXP );
        string __result = TsTv(i, j);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// NotAGap
bool NotAGap(char c);
RcppExport SEXP orthologr_NotAGap(SEXP cSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< char >::type c(cSEXP );
        bool __result = NotAGap(c);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// ambigousNucleotides
bool ambigousNucleotides(const std::string& codon);
RcppExport SEXP orthologr_ambigousNucleotides(SEXP codonSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< const std::string& >::type codon(codonSEXP );
        bool __result = ambigousNucleotides(codon);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// codonPrecondition
bool codonPrecondition(const std::string& codon);
RcppExport SEXP orthologr_codonPrecondition(SEXP codonSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< const std::string& >::type codon(codonSEXP );
        bool __result = codonPrecondition(codon);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// intToNuc
char intToNuc(int i);
RcppExport SEXP orthologr_intToNuc(SEXP iSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< int >::type i(iSEXP );
        char __result = intToNuc(i);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// nucToInt
int nucToInt(char c);
RcppExport SEXP orthologr_nucToInt(SEXP cSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< char >::type c(cSEXP );
        int __result = nucToInt(c);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// Universal
char Universal(string codon);
RcppExport SEXP orthologr_Universal(SEXP codonSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< string >::type codon(codonSEXP );
        char __result = Universal(codon);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// TranslateCodon
std::string TranslateCodon(string codon);
RcppExport SEXP orthologr_TranslateCodon(SEXP codonSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< string >::type codon(codonSEXP );
        std::string __result = TranslateCodon(codon);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}
// gestimator
void gestimator(string file, string file_out = "", int maxHits = 3, bool verbose = false, bool remove_all_gaps = false);
RcppExport SEXP orthologr_gestimator(SEXP fileSEXP, SEXP file_outSEXP, SEXP maxHitsSEXP, SEXP verboseSEXP, SEXP remove_all_gapsSEXP) {
BEGIN_RCPP
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< string >::type file(fileSEXP );
        Rcpp::traits::input_parameter< string >::type file_out(file_outSEXP );
        Rcpp::traits::input_parameter< int >::type maxHits(maxHitsSEXP );
        Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP );
        Rcpp::traits::input_parameter< bool >::type remove_all_gaps(remove_all_gapsSEXP );
        gestimator(file, file_out, maxHits, verbose, remove_all_gaps);
    }
    return R_NilValue;
END_RCPP
}
// timesTwo
int timesTwo(int x);
RcppExport SEXP orthologr_timesTwo(SEXP xSEXP) {
BEGIN_RCPP
    SEXP __sexp_result;
    {
        Rcpp::RNGScope __rngScope;
        Rcpp::traits::input_parameter< int >::type x(xSEXP );
        int __result = timesTwo(x);
        PROTECT(__sexp_result = Rcpp::wrap(__result));
    }
    UNPROTECT(1);
    return __sexp_result;
END_RCPP
}