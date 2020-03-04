
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

class Sort {
   sortedl : List <- new List;
   notsortedlist : List;
   temp : Int <- 0;
   findmin(l : List) : Int {
      {
         temp <- l.head();
         l <- l.tail();
         notsortedlist <- new List;
         while not l.isNil()
         loop
         {
            if l.head() < temp then
            {
               notsortedlist <- notsortedlist.cons(temp);
               temp <- l.head();
            }
            else
               notsortedlist <- notsortedlist.cons(l.head())
            fi;
            l <- l.tail();
         }
         pool;
         temp;
      }
   };
   sortit(l : List) : List {
      {
         notsortedlist <- l;
         while not notsortedlist.isNil()
         loop
         {
            temp <- findmin(notsortedlist);
            sortedl <- sortedl.cons(temp);
         }
         pool;
         sortedl;
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
   print_list(l : List) : Object {
      if l.isNil() then out_string("\n")
      else 
      {
         out_int(l.head());
         out_string(" ");
         print_list(l.tail());
      }
      fi
   };
   main() : Object {
      {
         out_string("How many numbers to sort?\n");
         n <- in_int();
         get_list();
         mylist <- (new Sort).sortit(mylist);
         out_string("This is the sorted list:\n");
         print_list(mylist);
      }
   };
};
