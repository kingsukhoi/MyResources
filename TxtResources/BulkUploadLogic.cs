using System;
using System.Collections.Generic;
using System.Linq;

namespace Test2
{
    internal class Program
    {
        public static void Main(string[] args)
        {
            List<int> testList = new List<int>();
            for (int i = 0; i < 623; i++)
            {
                testList.Add(i);
            }
            
            
            IEnumerable<int> myEnumerator = testList;

            int pass = 0;
            const int importSize = 103;
            int numPasses = myEnumerator.Count()% importSize == 0 ? 
                (myEnumerator.Count()/importSize):
                ((myEnumerator.Count()/importSize)+1);
            
            Console.WriteLine(myEnumerator.Count());
            
            while (numPasses != 0)
            {
                IEnumerable<int> current = myEnumerator.Skip(importSize * pass).Take(importSize);

                foreach (int variable in current)
                {
                    var currpass = pass + 1;
                    Console.WriteLine($"Pass {currpass}, val{variable}");
                }


                numPasses--;
                pass++;
            }
            
            
            Console.WriteLine("done");
            Console.ReadLine();
        }
    }
}