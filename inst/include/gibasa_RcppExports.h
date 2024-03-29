// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#ifndef RCPP_gibasa_RCPPEXPORTS_H_GEN_
#define RCPP_gibasa_RCPPEXPORTS_H_GEN_

#include <Rcpp.h>

namespace gibasa {

    using namespace Rcpp;

    namespace {
        void validateSignature(const char* sig) {
            Rcpp::Function require = Rcpp::Environment::base_env()["require"];
            require("gibasa", Rcpp::Named("quietly") = true);
            typedef int(*Ptr_validate)(const char*);
            static Ptr_validate p_validate = (Ptr_validate)
                R_GetCCallable("gibasa", "_gibasa_RcppExport_validate");
            if (!p_validate(sig)) {
                throw Rcpp::function_not_exported(
                    "C++ function with signature '" + std::string(sig) + "' not found in gibasa");
            }
        }
    }

    inline bool dict_index_sys(const std::string& dic_dir, const std::string& out_dir, const std::string& encoding) {
        typedef SEXP(*Ptr_dict_index_sys)(SEXP,SEXP,SEXP);
        static Ptr_dict_index_sys p_dict_index_sys = NULL;
        if (p_dict_index_sys == NULL) {
            validateSignature("bool(*dict_index_sys)(const std::string&,const std::string&,const std::string&)");
            p_dict_index_sys = (Ptr_dict_index_sys)R_GetCCallable("gibasa", "_gibasa_dict_index_sys");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_dict_index_sys(Shield<SEXP>(Rcpp::wrap(dic_dir)), Shield<SEXP>(Rcpp::wrap(out_dir)), Shield<SEXP>(Rcpp::wrap(encoding)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<bool >(rcpp_result_gen);
    }

    inline bool dict_index_user(const std::string& dic_dir, const std::string& file, const std::string& csv_file, const std::string& encoding) {
        typedef SEXP(*Ptr_dict_index_user)(SEXP,SEXP,SEXP,SEXP);
        static Ptr_dict_index_user p_dict_index_user = NULL;
        if (p_dict_index_user == NULL) {
            validateSignature("bool(*dict_index_user)(const std::string&,const std::string&,const std::string&,const std::string&)");
            p_dict_index_user = (Ptr_dict_index_user)R_GetCCallable("gibasa", "_gibasa_dict_index_user");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_dict_index_user(Shield<SEXP>(Rcpp::wrap(dic_dir)), Shield<SEXP>(Rcpp::wrap(file)), Shield<SEXP>(Rcpp::wrap(csv_file)), Shield<SEXP>(Rcpp::wrap(encoding)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<bool >(rcpp_result_gen);
    }

    inline Rcpp::DataFrame dictionary_info(const std::string& sys_dic = "", const std::string& user_dic = "") {
        typedef SEXP(*Ptr_dictionary_info)(SEXP,SEXP);
        static Ptr_dictionary_info p_dictionary_info = NULL;
        if (p_dictionary_info == NULL) {
            validateSignature("Rcpp::DataFrame(*dictionary_info)(const std::string&,const std::string&)");
            p_dictionary_info = (Ptr_dictionary_info)R_GetCCallable("gibasa", "_gibasa_dictionary_info");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_dictionary_info(Shield<SEXP>(Rcpp::wrap(sys_dic)), Shield<SEXP>(Rcpp::wrap(user_dic)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<Rcpp::DataFrame >(rcpp_result_gen);
    }

    inline int transition_cost(unsigned short rcAttr, unsigned short lcAttr, const std::string& sys_dic = "", const std::string& user_dic = "") {
        typedef SEXP(*Ptr_transition_cost)(SEXP,SEXP,SEXP,SEXP);
        static Ptr_transition_cost p_transition_cost = NULL;
        if (p_transition_cost == NULL) {
            validateSignature("int(*transition_cost)(unsigned short,unsigned short,const std::string&,const std::string&)");
            p_transition_cost = (Ptr_transition_cost)R_GetCCallable("gibasa", "_gibasa_transition_cost");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_transition_cost(Shield<SEXP>(Rcpp::wrap(rcAttr)), Shield<SEXP>(Rcpp::wrap(lcAttr)), Shield<SEXP>(Rcpp::wrap(sys_dic)), Shield<SEXP>(Rcpp::wrap(user_dic)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<int >(rcpp_result_gen);
    }

    inline Rcpp::DataFrame posDebugRcpp(const std::vector<std::string>& text, const std::string& sys_dic = "", const std::string& user_dic = "", Rcpp::LogicalVector partial = 0) {
        typedef SEXP(*Ptr_posDebugRcpp)(SEXP,SEXP,SEXP,SEXP);
        static Ptr_posDebugRcpp p_posDebugRcpp = NULL;
        if (p_posDebugRcpp == NULL) {
            validateSignature("Rcpp::DataFrame(*posDebugRcpp)(const std::vector<std::string>&,const std::string&,const std::string&,Rcpp::LogicalVector)");
            p_posDebugRcpp = (Ptr_posDebugRcpp)R_GetCCallable("gibasa", "_gibasa_posDebugRcpp");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_posDebugRcpp(Shield<SEXP>(Rcpp::wrap(text)), Shield<SEXP>(Rcpp::wrap(sys_dic)), Shield<SEXP>(Rcpp::wrap(user_dic)), Shield<SEXP>(Rcpp::wrap(partial)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<Rcpp::DataFrame >(rcpp_result_gen);
    }

    inline Rcpp::DataFrame posParallelRcpp(const std::vector<std::string>& text, const std::string& sys_dic = "", const std::string& user_dic = "", Rcpp::LogicalVector partial = 0, const std::size_t& grain_size = 1) {
        typedef SEXP(*Ptr_posParallelRcpp)(SEXP,SEXP,SEXP,SEXP,SEXP);
        static Ptr_posParallelRcpp p_posParallelRcpp = NULL;
        if (p_posParallelRcpp == NULL) {
            validateSignature("Rcpp::DataFrame(*posParallelRcpp)(const std::vector<std::string>&,const std::string&,const std::string&,Rcpp::LogicalVector,const std::size_t&)");
            p_posParallelRcpp = (Ptr_posParallelRcpp)R_GetCCallable("gibasa", "_gibasa_posParallelRcpp");
        }
        RObject rcpp_result_gen;
        {
            RNGScope RCPP_rngScope_gen;
            rcpp_result_gen = p_posParallelRcpp(Shield<SEXP>(Rcpp::wrap(text)), Shield<SEXP>(Rcpp::wrap(sys_dic)), Shield<SEXP>(Rcpp::wrap(user_dic)), Shield<SEXP>(Rcpp::wrap(partial)), Shield<SEXP>(Rcpp::wrap(grain_size)));
        }
        if (rcpp_result_gen.inherits("interrupted-error"))
            throw Rcpp::internal::InterruptedException();
        if (Rcpp::internal::isLongjumpSentinel(rcpp_result_gen))
            throw Rcpp::LongjumpException(rcpp_result_gen);
        if (rcpp_result_gen.inherits("try-error"))
            throw Rcpp::exception(Rcpp::as<std::string>(rcpp_result_gen).c_str());
        return Rcpp::as<Rcpp::DataFrame >(rcpp_result_gen);
    }

}

#endif // RCPP_gibasa_RCPPEXPORTS_H_GEN_
