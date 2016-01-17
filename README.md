# ten-key-calculator

    This calculator was created as part of the Udemy.com course, 
    "iOS 9 and Swift 2: From Beginner to Paid Professional," by 
    Mark Price, lectures 40-41.

    I chose to implement a traditional 10-key desk calculator with
    the following features:

        Combination On/Clear/Off button
        Added a decimal.
        5 numeric operations (add, subtract, divide, multiply, and percent)
        Four single-register memory keys (clear, add to, subtract from, and recall).

    Some limitations.
        
        The LCD does not respond perfectly to overrange. It appends '...' to numbers 
        that are too large (or small) for the display.

        I played around with the autolayout for quite a while. I wanted it to grow or 
        shrink to a percentage of the host device. I was unsuccessful with that, and 
        I ended up having to use fixed values for some elements to ensure alignment 
        and position.
