uses System.Globalization, 
     System.IO,
     System;

{$region Type}

type
  Entry = record
    DateAndTime: DateTime;
    Task: string;
    Done: boolean;
    
    Constructor (NewDateAndTime: DateTime; NewTask: string; NewDone: boolean);
    begin
      DateAndTime := NewDateAndTime;
      Task := NewTask; 
      Done := NewDone; 
    end;
    
    function WithDone(New_status:boolean):Entry;
    begin
      Result := self;
      Result.Done := New_status;
    end;
    
    function WithTask(New_Task: string): Entry;
    begin
      Result := self;
      Result.Task := New_Task;
    end;
    
    function WithDateAndTime(New_Date: datetime): Entry;
    begin
      Result := self;
      Result.DateAndTime := New_Date;
    end;
    
  end;
  
{$endregion Type}

{$region Compare}

function CompareEntriesByTime(Entry1, Entry2: Entry): integer;
begin
  Result :=DateTime.Compare(Entry1.DateAndTime,Entry2.DateAndTime);
end;

{$endregion Compare}

{$region Add}

procedure AddEntry(Diary: List<Entry>);
begin
  try
    Diary.Add(Entry.Create(DateTime.ParseExact(readstring('Введите дату (дд.мм.гггг чч:мм): '), 'dd.MM.yyyy HH:mm', new CultureInfo('ru-RU')),readstring('Введите описание к событию: '),false));
  except
    on e: System.FormatException do 
      begin
        println;
        ('Ошибка при вводе даты и времени: ', e.Message).Println;
        println;
        exit;
      end;
  end;
  println;
  Diary.Sort(CompareEntriesByTime);
end;

{$endregion Add}

{$region Print}

procedure PrintEntries(Diary: List<Entry>);
begin
  var ru_ci := CultureInfo.CreateSpecificCulture('ru-RU');
  if Diary.Count = 0 then
  begin
    'Дневник пуст.'.Println;
    println;
    Exit;
  end;

  'События в дневнике:'.Println;
  println;

  var CurrentDate := Diary[0].DateAndTime;
  var CurrentYear := CurrentDate.Year;
  var CurrentMonth := CurrentDate.Month;
  var CurrentDayOfWeek := CurrentDate.DayOfWeek;

  string.Format(ru_ci,'Год: {0}',CurrentYear).Println;
  string.Format(ru_ci,'Месяц: {0}',Diary[0].DateAndTime.ToString('MMMM', CultureInfo.CurrentCulture)).Println;
  string.Format(ru_ci,'День недели: {0}',Diary[0].DateAndTime.ToString('dddd', CultureInfo.CurrentCulture)).Println;

  for var i := 0 to Diary.Count - 1 do
  begin
    if (Diary[i].DateAndTime.Year <> CurrentYear) then
    begin
      CurrentYear := Diary[i].DateAndTime.Year;
      string.Format(ru_ci,'Год: {0}',CurrentYear).Println;
    end;

    if (Diary[i].DateAndTime.Month <> CurrentMonth) then
    begin
      CurrentMonth := Diary[i].DateAndTime.Month;
      string.Format(ru_ci,'Месяц: {0}',Diary[i].DateAndTime.ToString('MMMM', CultureInfo.CurrentCulture)).Println;
    end;

    if Diary[i].DateAndTime.DayOfWeek <> CurrentDayOfWeek then
    begin
      CurrentDayOfWeek := Diary[i].DateAndTime.DayOfWeek;
      string.Format(ru_ci,'День недели: {0}',Diary[i].DateAndTime.ToString('dddd', CultureInfo.CurrentCulture)).Println;
    end;
    println;
    string.Format(ru_ci,'{0}. {1} - {2} - {3}',i+1 ,Diary[i].DateAndTime.ToString('dd.MM.yyyy HH:mm'), Diary[i].Task, Diary[i].Done).Println;
    println;
  end;

  Println('-'*50);
end;

{$endregion Print}

{$region Edit}

procedure EditEntry(Diary: List<Entry>);
begin
  var Entry_Ind : integer;
  repeat
    Console.Clear; 
    PrintEntries(Diary);
    if Diary.Count = 0 then
    begin
      'Ежедневник пуст.'.Println;
      exit;
    end;
    Entry_Ind := ReadLnInteger('Выберите порядковый номер записи, которую хотите изменить/удалить:') - 1;
  until (cardinal(Entry_Ind) < Diary.Count);
 
  while true do
  begin
    Console.Clear;
    'Что хотите изменить?'.PrintLn;
    PrintLn;
    'A - Дату и время события'.PrintLn;
    'B - Описание события'.PrintLn;
    'C - Статус события'.PrintLn;
    'D - Удалить запись'.Println;
    'X - Назад'.PrintLn;
    println;
    
    var Choice := ReadLnChar('Выбор: ');
    case upcase(choice) of
      'A': 
      begin
        try
          Diary[Entry_Ind] := Diary[Entry_Ind].WithDateAndTime(DateTime.ParseExact(readstring('Введите дату и время события (дд.мм.гггг чч:мм): '),'dd.MM.yyyy HH:mm', new CultureInfo('ru-RU')));
        except
          on e: System.FormatException do 
          begin
            ('Ошибка при вводе даты и времени: ', e.Message).Println;
            break;
          end;
        end;
      end;
             
      'B': Diary[Entry_Ind] := Diary[Entry_Ind].WithTask(ReadLnString('Введите новое описание события: '));

      'C': Diary[Entry_Ind] := Diary[Entry_Ind].WithDone(ReadLnBoolean('Введите новый статус события (True/False): '));

      'D': 
      begin
        Diary.RemoveAt(Entry_Ind);
        'Запись удалена.'.Println;
      end;
        
      'X': break;
        
      else 'Неправильный ввод данных.'.Println;
        
    end;
  end; 
  println;
end;

{$endregion Edit}

{$region ToFile}

procedure WriteToFile(Diary: List<Entry>);
begin
  var sw := new StreamWriter(new FileStream('diary.txt', FileMode.Create));
  for var i := 0 to Diary.Count - 1 do sw.WriteLine(Diary[i].DateAndTime + '|' + Diary[i].Task + '|' + Diary[i].Done.ToString());
  sw.Close();
end;

{$endregion toFile}

{$region FromFile}

function ReadFromFile(): List<Entry>;
begin
  var sr := new StreamReader(new FileStream('diary.txt', FileMode.OpenOrCreate));
  var Diary := new List<Entry>;
  while not sr.EndOfStream do
    begin
      var parts := sr.ReadLine.Split('|');
      var new_entry: Entry := New Entry(DateTime.Parse(parts[0]),parts[1],Boolean.Parse(parts[2]));
      Diary.Add(new_entry);
    end;
  sr.Close();
  Diary.Sort(CompareEntriesByTime);
  Result := Diary;
end;

{$endregion FromFile}

{$region Menu}

Procedure MainMenu(Diary: List<Entry>);
begin
  Diary := ReadFromFile;
  while true do
    begin
      'A - Добавление события'.PrintLn;
      'B - Просмотр событий'.PrintLn;
      'C - Редактирование событий'.Println;
      'D - Очистка ежедневника'.Println;
      'X - Выход'.Println;
      println;
      var choice := ReadLnChar('Выбор: ');
      Console.Clear;
      case choice of
        'A': AddEntry(Diary);
        'B': PrintEntries(Diary);
        'C': EditEntry(Diary);
        'D': Diary.Clear;        
        'X': 
        begin
          'До свидания!'.PrintLn;
          break
        end;
        
        else
          begin
            'Ваш выбор не соответствует предложенному, попробуйте еще раз'.Println;
            println;
          end;
      end;
    end;
    WriteToFile(Diary);
end;

{$endregion Menu}

begin
  MainMenu(new List<Entry>);
end.