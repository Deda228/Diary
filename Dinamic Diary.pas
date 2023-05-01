uses crt;

const
  MAX_ENTRIES = 100; // Максимальное количество записей

type
  Entry = record
    date: string; // Формат: dd/mm/yyyy
    time: string; // Формат: hh:mm
    task: string;
    done: boolean;
  end;

var
  entries: array [1..MAX_ENTRIES] of Entry;
  entryCount: integer;


// Создание или редактирование файла с невыполненными задачами
procedure CreateOrModifyFile;
var
  fileVar: TextFile;
begin
  ClrScr;
  var filename := readstring('Enter the name of the file to create/modify: ') + '.txt';
  writeln;
  AssignFile(fileVar, filename);
  if FileExists(filename) then
    Append(fileVar)
  else
    Rewrite(fileVar);
  for var i: integer := 1 to entryCount do
  begin
    if not entries[i].done then
      writeln(fileVar, entries[i].date, ' | ', entries[i].time, ' | ', entries[i].task);
  end;
  CloseFile(fileVar);
  println('File created/modified successfully.');
end;

// Вспомогательная функция для сравнения двух записей
function CompareEntries(entry1, entry2: Entry): integer;
begin
  if entry1.date <> entry2.date then
    CompareEntries := compareStr(entry1.date, entry2.date)
  else
    CompareEntries := compareStr(entry1.time, entry2.time);
end;

// Алгоритм пузырьковой сортировки для сортировки записей по дате и времени
procedure SortEntries;
begin
  for var i: integer := 1 to entryCount - 1 do
  begin
    for var j: integer := i + 1 to entryCount do
    begin
      if CompareEntries(entries[i], entries[j]) > 0 then
      begin
        var tempEntry : entry := entries[i];
        entries[i] := entries[j];
        entries[j] := tempEntry;
      end;
    end;
  end;
end;

// Отобразить все записи в ежедневнике
procedure DisplayEntries;
begin
  ClrScr;
  SortEntries;
  println('Date        Time    Task                      Done');
  println('--------------------------------------------------');
  for var i: integer := 1 to entryCount do
    writeln(entries[i].date, '   ', entries[i].time, '   ', entries[i].task, '   ', entries[i].done);
end;

// Отобразить записи, соответствующие заданным параметрам поиска
procedure SearchEntries;
begin
  ClrScr;
  var found : boolean := false;
  println('Enter the search criteria (press Enter for any field you do not wish to search for):');
  println;
  var searchDate := readstring('Date (dd/mm/yyyy): ');
  var searchTime := readstring('Time (hh:mm): ');
  var searchTask := readstring('Task: ');
  SortEntries;
  println;
  println('Search results:');
  println('----------------');
  println('Date        Time    Task                      Done');
  println('--------------------------------------------------');
  for var i: integer := 1 to entryCount do
    begin
      if ((searchDate = '') or (entries[i].date = searchDate)) and
      ((searchTime = '') or (entries[i].time = searchTime)) and
      ((searchTask = '') or (pos(searchTask, entries[i].task) > 0)) then
        begin
          writeln(entries[i].date, ' ', entries[i].time, ' ', entries[i].task, ' ', entries[i].done);
          found := true;
        end;
    end;
  if not found then
  println('No entries found.');
end;

// Добавить новую запись в ежедневник
procedure AddEntry;
var
  newEntry: Entry;
begin
  ClrScr;
  println('Enter the date (dd/mm/yyyy): ');
  readln(newEntry.date);
  writeln;
  println('Enter the time (hh:mm): ');
  readln(newEntry.time);
  writeln;
  println('Enter the task: ');
  readln(newEntry.task);
  writeln;
  newEntry.done := false;
  if entryCount < MAX_ENTRIES then
  begin
    entryCount += 1;
    entries[entryCount] := newEntry;
    println('Entry added successfully.');
  end
  else
    println('Diary is full. Cannot add more entries.');
end;

// Удаление записи из ежедневника
procedure DeleteEntry;
begin
  ClrScr;
  var date := readstring('Enter the date (dd/mm/yyyy) of the entry to delete: ');
  var time := readstring('Enter the time (hh:mm) of the entry to delete: ');
  var index : integer := -1;
  for var i: integer := 1 to entryCount do
    begin
      if (entries[i].date = date) and (entries[i].time = time) then
        begin
          index := i;
          break;
        end;
    end;
  if index <> -1 then
    begin
      for var i: integer := index to entryCount - 1 do
        entries[i] := entries[i + 1];
      entryCount -=  1;
      println('Entry deleted successfully.');
    end
  else
    println('Entry not found.');
end;

// Отметить запись как выполненную 
procedure MarkEntry;
var
  date, time: string;
  found: boolean;

begin
  ClrScr;
  println('Enter the date (dd/mm/yyyy) of the entry to mark: ');
  readln(date);
  writeln;
  println('Enter the time (hh:mm) of the entry to mark: ');
  readln(time);
  writeln;
  found := false;
  for var i: integer := 1 to entryCount do
  begin
    if (entries[i].date = date) and (entries[i].time = time) then
    begin
      found := true;
      if entries[i].done then
        entries[i].done := false
      else
        entries[i].done := true;
      break;
    end;
  end;
  if found then
    println('Entry marked successfully.')
  else
    println('Entry not found.');
end;

//Интерфейс
procedure MainMenu;
var
  choice: integer;
begin
  repeat
    writeln;
    println('1. Display all entries');
    println('2. Add a new entry');
    println('3. Delete an entry');
    println('4. Mark an entry as done');
    println('5. Search entries');
    println('6. Create/Modify a file with undone tasks');
    println('7. Exit');
    println('Enter your choice (1-7): ');
    writeln;
    readln(choice);
    writeln;
    case choice of
      1: DisplayEntries;
      2: AddEntry;
      3: DeleteEntry;
      4: MarkEntry;
      5: SearchEntries;
      6: CreateOrModifyFile;
      7: writeln('Goodbye!')
    else
      begin
        ClrScr; 
        println('Invalid choice. Please try again.');
      end;
    end;
  until choice = 7;
end;

// Основная часть программы

begin
  mainmenu;
end.