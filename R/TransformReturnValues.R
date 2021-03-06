##  -----------------------------------------------------------
##  pyTransformReturn
##  =================
##
##  Is used to transform the return values it is not integrated
##  into pyGet so it can be reused for pyCall.
##
## -----------------------------------------------------------

pyTransformReturn <- function(obj) obj

setGeneric("pyTransformReturn")

setClass("PythonObject")
setMethod("pyTransformReturn", signature(obj = "PythonObject"),
          function(obj){
    variableName <- sprintf("__R__.namespace[%i]", obj$id)
    if (obj$isCallable){
        return(pyFunction(variableName, regFinalizer = TRUE))
    }else if ( obj$type == "list" ){
        return(pyList(variableName, regFinalizer = TRUE))
    }else if ( obj$type == "dict" ){
        return(pyDict(variableName, regFinalizer = TRUE))
    }else if ( obj$type == "DataFrame" ){
        pyExec(sprintf("x = %s.to_dict(orient='list')", variableName))
        return( as.data.frame(pyGet("x"), optional=TRUE, stringsAsFactors=FALSE) )
    }else{
        return(pyObject(variableName, regFinalizer = TRUE))
    }
})
