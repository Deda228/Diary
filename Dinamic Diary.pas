{$apptype windows}
{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

uses System.Windows;
uses System.Windows.Controls;

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
 
function AddEntry(Diary: List<Entry>): object; 
begin
  var SP := new StackPanel;
  
  var T1 := new System.Windows.Controls.Label;
  SP.Children.Add(T1);
  T1.Content := 'Введите описание события:';
  T1.FontSize := 20;
  T1.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var TB := new TextBox;
  SP.Children.Add(TB);
  TB.FontSize := 25;
  TB.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var T2 := new System.Windows.Controls.Label;
  SP.Children.Add(T2);
  T2.Content := 'Введите дату события:';
  T2.FontSize := 20;
  T2.HorizontalContentAlignment := HorizontalAlignment.Center; 
  
  var DP := new DatePicker;
  SP.Children.Add(DP);
  DP.FontSize := 20;
  DP.HorizontalContentAlignment := HorizontalAlignment.Center; 
  
  var addButton := new Button;
  SP.Children.Add(addButton);
  addbutton.Content := 'Подтвердить';
  addButton.Click += (o,e) -> 
    begin
      Diary.Add(Entry.Create(DP.SelectedDate.Value, TB.Text, False));
      SP.Children.Clear();
    end;
    
  result := SP;
end;

{$endregion Add} 

{$region Menu}

Procedure MainMenu(Diary: List<Entry>);
begin
  var win := new window;
  win.Name:='Diary';
  var Okn := new DockPanel;
  var SV := new ScrollViewer;
  var CC := new ContentControl;
  var Butcont := new StackPanel; 
  Dockpanel.SetDock(Okn,Dock.Left);
  SV.VerticalScrollBarVisibility := scrollbarvisibility.Auto;
  SV.HorizontalScrollBarVisibility := scrollbarvisibility.Auto;
  
  var add_button := procedure(name: string; when_clicked: ()->object)->
  begin
    var button := new Button;
    button.Content := name;
    button.Width := 200;
    button.Height := 100;
    button.Click += (o,e) -> 
      begin 
        CC.Content :=  when_clicked(); 
      end;
    Butcont.Children.Add(button);
  end;
  
  add_button('Добавить событие', ()-> AddEntry(Diary));
  //add_button('Показать  событие', ()->  );
  //add_button('Редактировать событие', ()->  );
  //add_button('Очистить ежедневник', ()->  );
  //add_button('Выход', () -> );
  
  SV.Content := Butcont;
  Okn.Children.Add(SV);
  Okn.Children.Add(CC);
  
  win.Content := Okn;
  Application.Create.Run(win);
end;

{$endregion Menu}

{$region Main}
begin
  MainMenu(new List<Entry>);
end.
{$endregion Main}