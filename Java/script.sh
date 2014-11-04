#!/bin/bash
echo "---Starting script---"
javac -classpath *:. WebDriverInvolved.java; java -classpath *:. WebDriverInvolved &
pid1=$!
java -classpath *:. WebDriverInvolved &
pid2=$!
java -classpath *:. WebDriverInvolved &
pid3=$!
wait $pid1
wait $pid2
wait $pid3
echo "---Ending script---"
