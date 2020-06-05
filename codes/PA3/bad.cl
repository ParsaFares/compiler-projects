(* no error *)
class A {
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error:  a is not a type identifier *)
Class C inherits a {
};

(* error:  keyword inherits is misspelled *)
Class D inherts A {
};

(* error in let *)
class Main inherits IO {
    main() : SELF_TYPE {
        (let c : Complex <- (new Complex).init(1, 1), d in
         if c.reflect_X().reflect_Y() = c.reflect_0() then out_string("=)\n") else out_string("=(\n") fi
         )
    };
};

class Complex inherits IO {
    x : Int;
    y : Int;
    
    
    
    print() : Object {
        if y = 0
            then out_int(x)
            else out_int(x).out_string("+").out_int(y).out_string("I")
                fi
                };
    
    reflect_0() : Complex {
        {
            x = ~x;
            y = ~y;
            self;
        }
    };
    
    reflect_X() : Complex {
        {
            y = ~y;
            self;
        }
    };
    
    reflect_Y() : Complex {
        {
            x = ~x;
            self;
        }
    };
};


(* some errors in features *)
class R iNherItS A{
    bad_func () : INT {
        BadContent
    };
    (* some errors in block *)
    meThOD () : Object {
        {
            LET IN
            Isvoi test;
            XAR <- 42;
            2 * 5;
        }
    };
};

(* error:  closing brace is missing *)
Class E inherits A {
;
