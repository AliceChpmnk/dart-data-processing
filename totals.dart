import 'dart:io';

void main(List<String> arguments)
//now we can read arguments from the console
{
  if (arguments.isEmpty) {
    print('Usage: dart tools.dart <inputFile.csv>');
    exit(1);
    //terminate program immediately when called without arguments: non-zero error code on failure
  }
  final inputFile = arguments.first;
  //get the first element from the list (argumrnts) - it's the path to our file
  final lines = File(inputFile).readAsLinesSync();
  //File(inputFile) creates a handle or a reference to the file using the value that was passed as the argument
  // and then .readAsLinesSync() reads all the content in one go and returns them as a list of Strings
  final totalDurationByTag = <String, double>{};
  // created an empty map
  lines.removeAt(0);
  //remove the first line of the list "lines" as it contains the header for the entire data
  var totalDuration = 0.0;
  // this is needed to count the total duration at the end (without tag division)
  for (var line in lines) {
    // at this point we take lines one by one (iterate)
    //and perform all actions below to each line separately
    final values = line.split(',');
    // transforms 'line' which is String to the List with values
    // for each line creates a list with all the values by spliting the line using a coma as a separater
    final durationStr = values[3].replaceAll('"', '');
    //replace all quotes with empty space
    //to be able to transform durationStr (String) to Double on the next step
    //(because the values of duration should be numbers so that we can sum them up later)
    final duration = double.parse(durationStr);
    //gives us a duration as a number (not a String)
    final tag = values[5].replaceAll('"', '');
    // for these values we don't need to change String type, because they are words
    // next we need to update our map:
    final previousTotal = totalDurationByTag[tag];
    // previousTotal variable will contain a totaL duration for a given tag up to this point in the loop
    // but if it's the first time we encounter a given tag, then this value will be null
    // because we try to find it in an empty map (or in a map updated with other tags, not this one)
    // so in the next steps we want to either update the map with the new tag if it doesn't exist yet
    // or set a new value to the existing tag
    //so that it would be "the previous value + the value from the line we process"
    if (previousTotal == null) {
      totalDurationByTag[tag] = duration;
      // so if there is no key with the 'tag' name in our map, this code updates out map:
      // this code will create a new key (with the name of the [tag]) in our map 'totalDurationByTag'
      // and will assign a value of 'duration' to this new key
    } else {
      // if we already added the tag to the map, the previous if-condition will be skipped
      // At this point previousTotal will have has the 'duration' value of the previous line with the same tag
      // because previousTotal only takes the meaning from the map
      // and if the first time previousTotal was null, after it will always have the meaning from the previous loop
      // so we need to update the map value of the key with the name of our [tag]
      // so that the next time previousTotal has the value it has now + duration from the line that we process in this loop
      totalDurationByTag[tag] = previousTotal + duration;
      // this code updates the map value at the key of [tag] name
      //so every time the loop meets the [tag] it will update the value of the key named [tag]
      // summing it with the duration value from the line that is processed in the loop
    }
    totalDuration += duration;
    //this code will just sum up all the durations no matte what tag is processed
  }
// cool! at this point the loop ends and now we have the map totalDurationByTag
// with all tags we have in the csv file as the keys of the map
// and values to this keys which are sums of all durations of this tag
  // next thing to do: to show the results
  // let's add entry that iterates through all the entries in the map
  for (var entry in totalDurationByTag.entries) {
    final durationFormatted = entry.value.toStringAsFixed(1);
    // this code will represent the number as decimal with only 1 fractional digit
    final tag = entry.key == "" ? 'Unallocated' : entry.key;
    // this is the ternary operator
    // checks if the tag is missing by comparing it with an empty String
    // and if true,then we treat it as an 'Unallocated'
    // if false (tag is not empty) then we just assign key (that is tag name) to the tag variable
    print('$tag: ${durationFormatted}h');
  }
  print('Total for all tags: ${totalDuration.toStringAsFixed(1)}h');
}

// lines = readFile(inputFile) given the lines that represent the content of our csv file
// durationByTag = empty map - we now define variable called durationByTag
// lines.removeFirst() remove the first line as it contains the header for the entire data
// for (line in lines) iterate through all the lines with a for loop
// values = line.split(',') for each line get all the values by spliting the line using a coma as a separater
// duration = values [3]
// tag = values [5] read the duration and tag values which can be found at index 3 and 5
// update(durationByrag[tag], duration) - adding a duration value
// end (once the loop is complete)
// printAll(durationByTag)
