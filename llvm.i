%module LLVM 
%{
#define __STDC_CONSTANT_MACROS
#define __STDC_LIMIT_MACROS
#include "llvm/Use.h"
#include "llvm/User.h"
#include "llvm/Value.h"
#include "llvm/Constant.h"
#include "llvm/Constants.h"
#include "llvm/BasicBlock.h"
#include "llvm/GlobalValue.h"
#include "llvm/Function.h"
#include "llvm/Type.h"
#include "llvm/DerivedTypes.h"
#include "llvm/Module.h"
#include "llvm/Pass.h"
#include "llvm/AbstractTypeUser.h"
#include "llvm/LLVMContext.h"
using namespace llvm;
%}

#define __STDC_CONSTANT_MACROS
#define __STDC_LIMIT_MACROS

%include "std_vector.i"
%include "std_string.i"

%include "llvm/OperandTraits.h"
%include "llvm/Value.h"
%include "llvm/User.h"
%include "llvm/Constant.h"
%include "llvm/Constants.h"


%include "llvm/ADT/ilist_node.h"

%template(Ilist_node__BasicBlock) ::llvm::ilist_node<BasicBlock>;
%template(Ilist_node__Function) ::llvm::ilist_node<Function>;

%rename(to_type) operator Type*;

%ignore *::refineAbstractType;
%ignore *::typeBecameConcrete;
%ignore llvm::Pass::getAdjustedAnalysisPointer;
%ignore llvm::GlobalValue::use_empty_except_constants;

%include "llvm/BasicBlock.h"
%include "llvm/Support/Compiler.h"

%include "llvm/GlobalValue.h"
%include "llvm/Function.h"


%include "llvm/AbstractTypeUser.h"
%include "llvm/Type.h"

%include "llvm/System/DataTypes.h"
%include "llvm/DerivedTypes.h"

// typemaps for StringRef
%typemap(in) StringRef {
    $1 = StringRef(RSTRING_PTR($input), RSTRING_LEN($input));
}

%typemap(out) StringRef {
    $result = rb_str_new($1.data(), $1.size());
}

// for overloading in llvm/Module.h
%typemap(typecheck) StringRef {
    $1 = TYPE($input) == T_STRING;
}

%include "llvm/Module.h"
%include "llvm/Pass.h"

%include "llvm/LLVMContext.h"
