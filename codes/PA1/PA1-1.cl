class Main inherits IO {
   c : Int <- 0;
   t : Bool <- true;
   check(s : String) : Bool {
      {
         (let i : Int <- 0 in
            while not i = s.length()
            loop
               {
                  if s.substr(i,1) = "(" then c <- c+1 else
                  if 0 < c then c <- c - 1 else
                  t <- false
                  fi fi;
                  i <- i + 1;
               }
            pool
         );
         if t then 
            if c = 0 then true else
            false
            fi
         else false
         fi;
      }
   };
   a : String;
   main(): SELF_TYPE {
      {
         out_string("Enter parenthese:\n");
         a <- in_string();
         out_string("The answer is:\n");
         if check(a) then
            out_string("True\n")
         else
            out_string("False\n")
         fi;
      }
   };
};
