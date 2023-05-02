uses System.Globalization; 

type
  Entry = record
    Time: DateTime;
    Task: string;
    Done: boolean;
  end;

{$region Compare}
  
function CompareEntriesByTime(const Entry1, Entry2: Entry): integer;
begin
  Result :=DateTime.Compare(Entry1.time,Entry2.Time);
end;

{$endregion}

{$region Add}
procedure AddEntry(Diary: List<Entry>);
begin
  var NewEntry: Entry;
  try
    NewEntry.Time := DateTime.ParseExact(readstring('Введите дату (дд.мм.гггг чч:мм): '), 'dd.MM.yyyy HH:mm', new CultureInfo('ru-RU'));
  except
    on e: System.FormatException do 
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
{$endregion}

{$region Print}
procedure PrintEntries(Diary: List<Entry>);
begin
  
  if Diary.Count = 0 then
  begin
    Console.WriteLine('Дневник пуст.');
    println;
    Exit;
  end;

  Console.WriteLine('События в дневнике:');
  println;

  var CurrentDate := Diary[0].Time;
  var CurrentYear := CurrentDate.Year;
  var CurrentMonth := CurrentDate.Month;
  var CurrentDayOfWeek := integer(CurrentDate.DayOfWeek);

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
{$endregion}

{$region Edit}
procedure EditEntry(Diary: List<Entry>); 
begin
  var num : integer;
  repeat
    Console.Clear; 
    PrintEntries(Diary);
    num := ReadLnInteger('Выберите порядковый номер записи, которую хотите изменить:');
  until (num <= Diary.Count) and (num > 0);
 
  While true do
    begin
      Console.Clear;
      writeln('Что хотите изменить?');
      writeln;
      writeln('A - Дату и время события');
      writeln('B - Описание события');
      writeln('C - Статус события');
      writeln('X - Назад');
      writeln;
      var Choice := ReadLnChar('Выбор: ');
      var REntry : Entry;
      case upcase(choice) of
        
        'X': Break;
        
        'A': begin
               try
                 REntry.Time := DateTime.ParseExact(readstring('Введите дату и время события (дд.мм.гггг чч:мм): '),'dd.MM.yyyy HH:mm', new CultureInfo('ru-RU'));
                 REntry.Done := Diary[num-1].Done;
                 REntry.Task := Diary[num-1].Task;
                 Diary[num-1] := REntry;
               except
                 on e: System.FormatException do begin
                   writeln;
                   writeln('Ошибка при вводе даты и времени: ', e.Message);
                   writeln;
                   exit;
                 end;
               end;
             end;
             
        'B': begin
               REntry.Task := ReadLnString('Введите новое описание события: ');
               REntry.Time := Diary[num-1].Time;
               REntry.Done := Diary[num-1].Done;
               Diary[num-1] := REntry;
             end;
             
        'C': begin
               REntry.Done := ReadLnBoolean('Введите новый статус события (True/False): ');
               REntry.Time := Diary[num-1].Time;
               REntry.Task := Diary[num-1].Task;
               Diary[num-1] := REntry;
             end;
             
        else writeln('Неправильный ввод данных.');
        
      end;
  end; 
  println;
end;
{$endregion}

{$region Menu}
Procedure MainMenu(Diary: List<Entry>);
begin
  while true do
    begin
      println('A - Добавление события');
      println('B - Просмотр событий');
      println('C - Редактирование событий');
      println('X - Выход');
      println;
      var choice := ReadLnChar('Выбор: ');
      Console.Clear;
      case choice of
        'A': AddEntry(Diary);
        'B': PrintEntries(Diary);
        'C': EditEntry(Diary);
        'X': begin 
              println('До свидания!');
              break
        end;
        else
          begin
            println('Ваш выбор не соответствует предложенному, попробуйте еще раз');
            println;
          end;
      end;
    end;
end;
{$endregion}

begin
  var Diary: List<Entry> := new List<Entry>;
  MainMenu(Diary);
end.