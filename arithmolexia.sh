#!/bin/bash
letters1=( 'Α' 'Β' 'Γ' 'Δ' 'Ε' 'ς' 'Ζ' 'Η' 'Θ' 'Ι' 'Κ' 'Λ' 'Μ' 'Ν' 'Ξ' 'Ο' 'Π' 'Q' 'Ρ' 'Σ' 'Τ' 'Υ' 'Φ' 'Χ' 'Ψ' 'Ω' )
letters2=( 'α' 'β' 'γ' 'δ' 'ε' 'ς' 'ζ' 'η' 'θ' 'ι' 'κ' 'λ' 'μ' 'ν' 'ξ' 'ο' 'π' 'q' 'ρ' 'σ' 'τ' 'υ' 'φ' 'χ' 'ψ' 'ω' )
letter_values=(1 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800  )
#A function that knows how to read (char by char) from a file with only one line and 1 word in this line
read_and_calc_word_value () {
  while IFS= read -r -n1 char
  do
    for i in {0..25}
    do
		char_isnotok=true
    	if [ "$char" == "${letters1[i]}" ] || [ "$char" == "${letters2[i]}" ] ;then
		  char_isnotok=false
          echo "Έχουμε το γράμμα $char , θέση $i στο αλφάβητο, με αξία  ${letter_values[i]} " #for debugging purposes 
          wordvalue=$(( ${wordvalue} + ${letter_values[i]} ))
          break #no reason to check the remaining i's until 25, go on and read next char, break out of for loop, staying in while loop
        fi 
    done
    if [ char_isnotok ] && [ $i -eq 25 ] && [ "$char" != "Ω" ] && [ "$char" != "ω" ] && [ "$char" != "" ]  ; then #
      echo "Μη αποδεκτός χαρακτήρ : <$char> " 
      wordvalue=0  # zeroing the wordvalue of specific unacceptable word 
      break # no need to read remaining letters of word. Exit function.
    fi
  done < $1
}
wordvalue=0
if [ "$1" != "" ] ; then #a file with words is given as command line argument to the script
  while read word #read from file , word by word
  do
    echo $word > /tmp/tmpwordfile.$$
    wordvalue=0
    read_and_calc_word_value /tmp/tmpwordfile.$$
    echo "Αριθμητική αξία : $word = $wordvalue "
  done < $1  # end read from file , word by word
  rm /tmp/tmpwordfile.$$
else #no file is given through command-line-arguments , so the script asks interactively the user for input of 1 word
  read -p "Δώσε λέξη με κεφαλαία , ή με μικρά δίχως τόνους: " word 
  echo $word > /tmp/tmpwordfile.$$
  read_and_calc_word_value /tmp/tmpwordfile.$$
  rm /tmp/tmpwordfile.$$
  echo "Αριθμητική αξία : $word = $wordvalue "
fi
exit
