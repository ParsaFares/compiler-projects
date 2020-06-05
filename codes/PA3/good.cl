class A {
ana(): Int {
(let x:Int <- 1 in 2)+3
};
};

Class BB__ inherits A {
};

class List {
    isNil() : Bool { true };
    
    head()  : Int { { abort(); 0; } };
   
        tail()  : List { { abort(); self; } };
    
    cons(i : Int) : List {
        (new Cons).init(i, self)
    };
    
};


class Cons inherits List {
    
    car : Int;    -- The element in this list cell
    
    cdr : List;    -- The rest of the list
    
    isNil() : Bool { false };
    
    head()  : Int { car };
    
    tail()  : List { cdr };
    
    init(i : Int, rest : List) : List {
        {
            car <- i;
            cdr <- rest;
            self;
        }
    };
    
};


class Main inherits IO {
    
    mylist : List;
    print_list(l : List) : Object {
        if l.isNil() then out_string("\n")
            else {
                out_int(l.head());
                out_string(" ");
                print_list(l.tail());
            }
        fi
    };
        
        main() : Object {
            {
                mylist <- new List.cons(1).cons(2).cons(3).cons(4).cons(5);
                while (not mylist.isNil()) loop
                {
                    print_list(mylist);
                    mylist <- mylist.tail();
                }
                pool;
            }
        };
    
};

class Main inherits IO {
    main() : SELF_TYPE {
        (let c : Complex <- (new Complex).init(1, 1) in
         if c.reflect_X().reflect_Y() = c.reflect_0()
         then out_string("=)\n")
         else out_string("=(\n")
         fi
         )
    };
};

class Complex inherits IO {
    x : Int;
    y : Int;
    
    init(a : Int, b : Int) : Complex {
        {
            x = a;
            y = b;
            self;
        }
    };
    
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



class List {
    isNil() : Bool { true };
    
    head()  : Int { { abort(); 0; } };
    
    tail()  : List { { abort(); self; } };
    
    get_i(i : Int) : Int { { abort(); 0; } };
    
    set_i(i : Int, j : Int) : Object { { abort(); self; } };
    
    cons(i : Int) : List {
        (new Cons).init(i, self)
    };
};


class Cons inherits List {
    
    car : Int;
    
    cdr : List;
    
    tmp : Int;
    
    isNil() : Bool { false };
    
    head()  : Int { car };
    
    tail()  : List { cdr };
    
    init(i : Int, rest : List) : List {
        {
            car <- i;
            cdr <- rest;
            self; }
    };
    
    get_i(i : Int) : Int {
        if i = 0 then self.head()
            else self.tail().get_i(i-1)
                fi
                };
    
    set_i(i : Int, j : Int) : Object {
        if i = 0 then car <- j
            else self.tail().set_i(i-1, j)
                fi
                };
};


class Main inherits IO {
    
    mylist : List;
    
    tmp : Int;
    len : Int;
    m : Int <- 0;
    n : Int <- 0;
    ans : Int <- 0;
    
    my_flag : Bool <- true;
    
    main() : Object {
        {
            out_string("How many numbers to sort?");
            len <- in_int();
            (let j : Int <- 0 in
             while j < len
             loop {
                 mylist <- (new Cons).init(in_int(),mylist);
                 j <- j + 1; }
             pool
             );
            while m < len
                loop {
                    while n < len
                        loop {
                            if m = n then 0
                                else if mylist.get_i(m) = mylist.get_i(n) then my_flag <- false
                                    else 0
                                        fi
                                        fi;
                            n <- n + 1; }
                    pool;
                    if my_flag = true then ans <- ans + 1
                        else 0
                            fi;
                    n <- 0;
                    m <- m + 1;
                    my_flag <- true;}
            pool;
            out_string("Answer = ");
            out_int(ans);
            out_string("\n"); }
    };
};
