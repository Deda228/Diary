uses System.Collections.Generic, System.Globalization; 

type
  Entry = record
    Time: DateTime;
    Task: string;
    Done: boolean;
  end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
  
function CompareEntriesByTime(const Entry1, Entry2: Entry): integer;
begin
  if Entry1.Time < Entry2.Time then
    Result := -1
  else if Entry1.Time > Entry2.Time then
    Result := 1
  else
    Result := 0;
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

procedure CreateList(var Diary: List<Entry>);
begin
  Diary := new List<Entry>;
end;

procedure AddEntry(var Diary: List<Entry>);
var
  NewEntry: Entry;
begin
  try
    NewEntry.Time := DateTime.Parse(readstring('Введите дату (дд.мм.гггг чч:мм): '), new CultureInfo('ru-RU'));
  except
    on e: Exception do 
      begin
        println;
        println('Ошибка при вводе даты и времени: ', e.Message);
        println;
        exit;
      end;
  end;
  NewEntry.Task := readstring('Введите описание к событию: ');
  println;
  NewEntry.Done := false;
  Diary.Add(NewEntry);
  Diary.Sort(CompareEntriesByTime);
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
procedure PrintEntries(var Diary: List<Entry>);
var
  CurrentYear, CurrentMonth, CurrentDayOfWeek: integer;
  CurrentDate: DateTime;
begin
  if Diary.Count = 0 then
  begin
    Console.WriteLine('Дневник пуст.');
    println;
    Exit;
  end;

  Console.WriteLine('События в дневнике:');
  println;

  CurrentDate := Diary[0].Time;
  CurrentYear := CurrentDate.Year;
  CurrentMonth := CurrentDate.Month;
  CurrentDayOfWeek := integer(CurrentDate.DayOfWeek);

  Console.WriteLine('Год: {0}', CurrentYear);
  Console.WriteLine('Месяц: {0}', Diary[0].Time.ToString('MMMM', CultureInfo.CurrentCulture));
  Console.WriteLine('День недели: {0}', Diary[0].Time.ToString('dddd', CultureInfo.CurrentCulture));

  for var i := 0 to Diary.Count - 1 do
  begin
    if (Diary[i].Time.Year <> CurrentYear) then
    begin
      CurrentYear := Diary[i].Time.Year;
      Console.WriteLine('Год: {0}', CurrentYear);
    end;

    if (Diary[i].Time.Month <> CurrentMonth) then
    begin
      CurrentMonth := Diary[i].Time.Month;
      Console.WriteLine('Месяц: {0}', Diary[i].Time.ToString('MMMM', CultureInfo.CurrentCulture));
    end;

    if (integer(Diary[i].Time.DayOfWeek) <> CurrentDayOfWeek) then
    begin
      CurrentDayOfWeek := integer(Diary[i].Time.DayOfWeek);
      Console.WriteLine('День недели: {0}', Diary[i].Time.ToString('dddd', CultureInfo.CurrentCulture));
    end;
    println;
    Console.WriteLine('{0}. {1} - {2} - {3}',i+1 ,Diary[i].Time.ToString('dd.MM.yyyy HH:mm'), Diary[i].Task, Diary[i].Done);
    println;
  end;

  println('-----------------------------------------');
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//Дописать код и исправить двойной вывод

procedure EditEntry(Var Diary: List<Entry>); 
var
  num: integer;
  choice: string;
  REntry: Entry;
begin
  PrintEntries(Diary);
  repeat
    num := readinteger('Выберите порядковый номер записи, которую хотите изменить:');
    println;
  until num <= diary.Count;
 
  Repeat
    println('Что хотите изменить?');
    println;
    println('A - Дату и время события');
    println('B - Описание события');
    println('C - Статус события');
    println('X - Назад');
    println;
    choice := readstring('Выбор: ');
    if (not choice.InRange('A','D')) And (choice <> 'X') then 
      begin
        writeln('Неправильный ввод данных.');
        continue;
      end;
    if 'X' in choice then exit;
    if 'A' in choice then
      begin
        try
          REntry.Time := DateTime.Parse(readstring('Введите дату (дд.мм.гггг чч:мм): '), new CultureInfo('ru-RU'));
          REntry.Done := Diary[num-1].Done;
          REntry.Task := Diary[num-1].Task;
          Diary[num-1] := REntry;
        except
          on e: Exception do 
            begin
              println;
              println('Ошибка при вводе даты и времени: ', e.Message);
              println;
              exit;
            end;
        end;
      end;
  until choice = 'X';
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

Procedure MainMenu(Var Diary: List<Entry>);
var
  choice: string;
begin
  Repeat
    println('A - Добавление события');
    println('B - Просмотр событий');
    println('C - Редактирование событий');
    println('X - Выход');
    println;
    Write('Выбор: ');
    readln(choice);
    case choice of
      'A':
        begin
          Console.Clear;
          AddEntry(Diary);
        end;
      'B':
        begin
          Console.Clear;
          PrintEntries(Diary);
        end;
      'C':
        begin
          Console.Clear;
          EditEntry(Diary);
        end;
      'X':
        begin
          Console.Clear;
          println('До свидания!');
        end
      else
        begin
          console.Clear;
          println('Ваш выбор не соответствует предложенному, попробуйте еще раз');
          println;
        end;
    end;
  until choice = 'X' ;
end;

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

var
  Diary: List<Entry>;

begin
  CreateList(Diary);
  MainMenu(Diary);
end.