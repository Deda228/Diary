uses system;

type
  Entry = record
    date: string; // Format: dd/mm/yyyy
    time: string; // Format: hh:mm
    task: string;
    done: boolean;
    next: ^Entry;
  end;
  
  EntryPtr = ^Entry;

var
  entryCount: integer;

procedure CreateDynamicStructure(var head: EntryPtr);
begin
  head := nil;
end;


// Create or modify a file with the uncompleted tasks
procedure CreateOrModifyFile(var entries: EntryPtr; entryCount: integer);
var
  fileVar: TextFile;
  filename: string;
  currentEntry: EntryPtr;
begin
  filename := readstring('Enter the name of the file to create/modify: ') + '.txt';
  writeln;
  AssignFile(fileVar, filename);
  if FileExists(filename) then
    Append(fileVar)
  else
    Rewrite(fileVar);
  currentEntry := entries;
  for var i: integer := 1 to entryCount do
  begin
    if not currentEntry^.done then
      writeln(fileVar, currentEntry^.date, ' | ', currentEntry^.time, ' | ', currentEntry^.task);
    currentEntry := currentEntry^.next;
  end;
  CloseFile(fileVar);
  writeln('File created/modified successfully.');
end;

// Helper function to compare two entries
function CompareEntries(entry1, entry2: EntryPtr): integer;
begin
  if entry1^.date <> entry2^.date then
    CompareEntries := compareStr(entry1^.date, entry2^.date)
  else
    CompareEntries := compareStr(entry1^.time, entry2^.time);
end;

// Bubble sort algorithm to sort entries by date and time
procedure SortEntries(var head: EntryPtr);
var
  currentEntry, prevEntry, tempEntry: EntryPtr;
  swapped: boolean;
begin
  if (head = nil) or (head^.next = nil) then
    exit;
  swapped := true;
  while swapped do
  begin
    swapped := false;
    prevEntry := nil;
    currentEntry := head;
    while currentEntry^.next <> nil do
    begin
      if CompareEntries(currentEntry, currentEntry^.next) > 0 then
      begin
        tempEntry := currentEntry^.next;
        currentEntry^.next := tempEntry^.next;
        tempEntry^.next := currentEntry;
        if prevEntry = nil then
          head := tempEntry
        else
          prevEntry^.next := tempEntry;
        prevEntry := tempEntry;
        swapped := true;
      end
      else
      begin
        prevEntry := currentEntry;
        currentEntry := currentEntry^.next;
      end;
    end;
  end;
end;

// Display all entries in the diary
procedure DisplayEntries(var entries: EntryPtr);
var
  currentEntry: EntryPtr;
  currentDate, currentYear: string;
  yearChanged, dayChanged: boolean;
begin
  SortEntries(entries);
  writeln('Date Time Task Done');
  writeln('--------------------------------------------------');
  currentEntry := entries;
  currentYear := '';
  while currentEntry <> nil do
  begin
    currentDate := currentEntry^.date;
    yearChanged := currentYear <> copy(currentDate, 7, 4);
    if yearChanged then
    begin
      if currentYear <> '' then
        writeln('--------------------------------------------------');
      currentYear := copy(currentDate, 7, 4);
      writeln('Year: ', currentYear);
      writeln;
    end;
    dayChanged := currentDate <> copy(currentDate, 1, 5);
    if dayChanged then
      writeln('Day: ', copy(currentDate, 1, 5));
      writeln();
    writeln(currentEntry^.time, ' ', currentEntry^.task, ' ', currentEntry^.done);
    currentEntry := currentEntry^.next;
  end;
end;


// Отметка записи как невыполненной
procedure MarkEntryUndone(var entries: EntryPtr);
var
  selectedDate, selectedTime: string;
  currentEntry: EntryPtr;
begin
  SortEntries(entries);
  selectedDate := readstring('Enter the date (dd/mm/yyyy) of the entry to mark as undone: ');
  selectedTime := readstring('Enter the time (hh:mm) of the entry to mark as undone: ');
  currentEntry := entries;
  while currentEntry <> nil do
  begin
    if (currentEntry^.date = selectedDate) and (currentEntry^.time = selectedTime) then
    begin
      currentEntry^.done := false;
      break;
    end;
    currentEntry := currentEntry^.next;
  end;
end;

function CheckDate(dateStr: string): boolean;
var
  day, month, year: integer;
begin
  CheckDate := true;
  if Length(dateStr) <> 10 then
    CheckDate := false
  else
  begin
    try
      day := StrToInt(Copy(dateStr, 1, 2));
      month := StrToInt(Copy(dateStr, 4, 2));
      year := StrToInt(Copy(dateStr, 7, 4));
      if (day < 1) or (day > 31) or (month < 1) or (month > 12) or (year < 1900) or (year > 2100) then
        CheckDate := false;
    except
      CheckDate := false;
    end;
  end;
end;

function CheckTime(timeStr: string): boolean;
var
  hour, minute: integer;
begin
  CheckTime := true;
  if Length(timeStr) <> 5 then
    CheckTime := false
  else
  begin
    try
      hour := StrToInt(Copy(timeStr, 1, 2));
      minute := StrToInt(Copy(timeStr, 4, 2));
      if (hour < 0) or (hour > 23) or (minute < 0) or (minute > 59) then
        CheckTime := false;
    except
      CheckTime := false;
    end;
  end;
end;

// Добавление новой записи в список
procedure AddEntry(var head: EntryPtr; var tail: EntryPtr);
var
  newEntry: EntryPtr;
begin
  new(newEntry);
  entryCount := entryCount + 1;
  writeln;
  repeat
    newEntry^.date := readstring('Enter date (dd/mm/yyyy): ');
  until CheckDate(newEntry^.date);
  repeat
    newEntry^.time := readstring('Enter time (hh:mm): ');
  until CheckTime(newEntry^.time);
  newEntry^.task := readstring('Enter task description: ');
  newEntry^.done := false;
  newEntry^.next := nil;
  if head = nil then
  begin
    head := newEntry;
    tail := newEntry;
  end
  else
  begin
    tail^.next := newEntry;
    tail := newEntry;
  end;
end;
// Редактирование существующей записи
procedure EditEntry(var entries: EntryPtr);
var
  selectedDate, selectedTime: string;
  currentEntry: EntryPtr;
  foundEntry: boolean;
begin
  SortEntries(entries);
  selectedDate := readstring('Enter the date (dd/mm/yyyy) of the entry to edit: ');
  selectedTime := readstring('Enter the time (hh:mm) of the entry to edit: ');
  currentEntry := entries;
  foundEntry := false;
  while (currentEntry <> nil) and (not foundEntry) do
  begin
    if (currentEntry^.date = selectedDate) and (currentEntry^.time = selectedTime) then
    begin
      currentEntry^.date := readstring('Enter new date (dd/mm/yyyy): ');
      currentEntry^.time := readstring('Enter new time (hh:mm): ');
      currentEntry^.task := readstring('Enter new task description: ');
      break;
    end
      else
    begin
      currentEntry := currentEntry^.next;
    end;
  end;
end;


// Отметка записи как выполненной
procedure MarkEntryDone(var entries: EntryPtr);
var
  selectedDate, selectedTime: string;
  currentEntry: EntryPtr;
  entryFound: boolean;
begin
  SortEntries(entries);
  selectedDate := readstring('Enter the date (dd/mm/yyyy) of the entry to mark as done: ');
  selectedTime := readstring('Enter the time (hh:mm) of the entry to mark as done: ');
  currentEntry := entries;
  entryFound := false;
  while (currentEntry <> nil) and (not entryFound) do
  begin
    if (currentEntry^.date = selectedDate) and (currentEntry^.time = selectedTime) then
    begin
      currentEntry^.done := true;
      entryFound := true;
    end;
    currentEntry := currentEntry^.next;
  end;
end;

// Очистка ежедневника
procedure ClearEntries(var entries: EntryPtr);
var
  currentEntry, nextEntry: EntryPtr;
begin
  currentEntry := entries;
  while currentEntry <> nil do
  begin
    nextEntry := currentEntry^.next;
    Dispose(currentEntry);
    currentEntry := nextEntry;
  end;
  entryCount := 0;
  entries := nil;
  writeln('All entries cleared.');
  readln;
end;

// Основная программа
procedure MainProgram;
var
  choice: char;
  entries, tail: EntryPtr;

begin
  CreateDynamicStructure(entries);
  tail := nil;
  entryCount := 0;
  repeat
    writeln('A - Add Entry');
    writeln('E - Edit Entry');
    writeln('D - Mark Entry as Done');
    writeln('U - Mark Entry as Undone');
    writeln('S - Display Entries Sorted by Date and Time');
    writeln('C - Clear All Entries');
    writeln('F - Create/Modify File with Uncompleted Tasks');
    writeln('X - Exit');
    writeln;
    write('Enter your choice: ');
    readln(choice);
    case choice of
      'A':
        begin
          Console.Clear;
          AddEntry(entries, tail);
        end;
      'E':
        begin
          Console.Clear;      
          EditEntry(entries);
        end;
      'D':
        begin
          Console.Clear;
          MarkEntryDone(entries);
        end;
      'U':
        begin
          Console.Clear;
          MarkEntryUndone(entries);
        end;
      'S':
        begin
          Console.Clear;
          DisplayEntries(entries);
        end;
      'C':
        begin
          Console.Clear;
          ClearEntries(entries);
        end;
      'F':
        begin
          Console.Clear;
          CreateOrModifyFile(entries, entryCount);
        end;
    end;
    writeln;
  until choice = 'X';
end;

begin
  console.Title := 'Ежедневник';
  console.Foregroundcolor := consolecolor.Yellow;
  MainProgram;
end.