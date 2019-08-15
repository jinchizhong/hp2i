#!/bin/sh

function filter() {
  echo "$1" | grep "$2" | sed 's/.*title: "\([^"]*\).*/\1/' | sed 's/&nbsp;/ /g' | sed 's/,.*  /, /' | sed "s/^/$year, /" | sed 's/\([0-9]*\)-mid/\1-07/; s/\(2[0-9]*\),/\1-01,/'
}

content=`curl -s "https://www.numbeo.com/property-investment/gmaps_rankings.jsp?indexToShow=getHousePriceToIncomeRatio"`
years=`echo "$content" | sed -n '/name="title"/,/select>/ p' | grep option | sed 's/.*value="\([^"]*\).*/\1/' | tac`

echo "YEAR, CITY, HP2I"

for year in $years; do
  content=`curl -s "https://www.numbeo.com/property-investment/gmaps_rankings.jsp?indexToShow=getHousePriceToIncomeRatio&title=$year"`
  filter "$content" "Beijing" $year
  filter "$content" "Hong Kong" $year
  filter "$content" "San Francisco" $year
done
