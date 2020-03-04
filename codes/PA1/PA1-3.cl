
class List {
   isNil() : Bool { true };
   head()  : Int { { abort(); 0; } };
   tail()  : List { { abort(); new List; } };
   cons(i : Int) : List {
      (new Cons).init(i, self)
   };
};

class Cons inherits List {
   car : Int;	-- The element in this list cell
   cdr : List;	-- The rest of the list
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

class Count {
   uniql : List <- new List;
   counter : Int <- 0;
   countit(l : List) : Int {
      {
         while not l.isNil()
         loop
            let handyl : List <- uniql, inlist : Bool <- false in
            {
               while not handyl.isNil()
               loop
                  if handyl.head() = l.head() then
                  {
                     inlist <- true;
                     handyl <- handyl.tail();
                  }
                  else
                  handyl <- handyl.tail()
                  fi
               pool;
               if not inlist then
               {
                  uniql <- uniql.cons(l.head());
                  counter <- counter + 1;
               }
               else
               counter <- counter
               fi;
               l <- l.tail();
            }
         pool;
         counter;
      }
   };
};

class Main inherits IO {
   mylist : List <- new List;
   n : Int;
   get_list() : Object
   {
      let i : Int <- 0 in
      while not n = i
      loop
      {
         i <- i + 1;
         out_string("Enter a number: (");
         out_int(i);
         out_string("/");
         out_int(n);
         out_string(")\n");
         mylist <- mylist.cons(in_int());
      }
      pool
   };
   main() : Object {
      {
         out_string("How many numbers are in list?\n");
         n <- in_int();
         get_list();
         out_string("The number of unique numbers is:\n");
         out_int((new Count).countit(mylist));
         out_string("\n");
      }
   };
};
