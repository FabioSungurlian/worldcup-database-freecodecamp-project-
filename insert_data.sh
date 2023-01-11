#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

getTeamId(){
  TEAM=$1
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM'")
  if [[ -z $TEAM_ID ]]
  then
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
    if [ "$INSERT_TEAM_RESULT" = "INSERT 0 1" ]
    then
      TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$TEAM'")"
    fi  
  fi
  echo $TEAM_ID
}
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  [ "$YEAR" = "year" ] && continue
  WINNER_ID=$(getTeamId "$WINNER")
  OPPONENT_ID=$(getTeamId "$OPPONENT")
  INSERT_QUERY=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")

done
# Do not change code above this line. Use the PSQL variable above to query your database.
