﻿{$apptype windows}
{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

uses System.Windows,
     System.Windows.Controls;

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
 
function AddEntry(Diary: List<Entry>): StackPanel; 
begin
  var SP := new StackPanel;
  
  var DockP0 := new DockPanel;
  DockP0.HorizontalAlignment := HorizontalAlignment.left;
  
  var T1 := new System.Windows.Controls.Label;
  DockP0.Children.Add(T1);
  T1.Content := 'Введите описание события:';
  T1.FontSize := 20;
  T1.VerticalAlignment := VerticalAlignment.Center;
  
  var TB := new TextBox;
  DockP0.Children.Add(TB);
  TB.MinWidth := 200;
  TB.TextWrapping := Textwrapping.Wrap;
  TB.FontSize := 25;
  TB.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  SP.Children.Add(DockP0);
   
  var EmptySpace1 := new System.Windows.Controls.Label;
  SP.Children.Add(EmptySpace1);
  EmptySpace1.Content := '';
  EmptySpace1.FontSize := 20;
   
  var DockP1 := new DockPanel;
  DockP1.HorizontalAlignment := HorizontalAlignment.left;
  
  var T2 := new System.Windows.Controls.Label;
  DockP1.Children.Add(T2);
  T2.Content := 'Введите дату события:';
  T2.FontSize := 20;
  T2.HorizontalContentAlignment := HorizontalAlignment.Center; 
  
  var DP := new DatePicker;
  DockP1.Children.Add(DP);
  DP.FontSize := 20;
  DP.Width := 230;
  DP.Language := System.Windows.Markup.XmlLanguage.GetLanguage('ru-RU');
  DP.SelectedDateFormat := DatePickerformat.Long;
  DP.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  SP.Children.Add(DockP1);
  
  var EmptySpace2 := new System.Windows.Controls.Label;
  SP.Children.Add(EmptySpace2);
  EmptySpace2.Content := '';
  EmptySpace2.FontSize := 20;
  
  var DockP2 := new DockPanel;
  DockP2.HorizontalAlignment := HorizontalAlignment.Left;
  
  
  var T3 := new System.Windows.Controls.Label;
  DockP2.Children.Add(T3);
  T3.Content := 'Введите время события: ';
  T3.FontSize := 20;
  T3.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var hourTextBox := new TextBox;
  DockP2.Children.Add(hourTextBox);
  hourTextBox.FontSize := 20;
  hourTextBox.Width := 50;
  hourTextBox.HorizontalContentAlignment := HorizontalAlignment.Center;
  hourTextBox.MaxLength := 2;
  
  var T4 := new System.Windows.Controls.Label;
  DockP2.Children.Add(T4);
  T4.Content := ':';
  T4.FontSize := 20;
  T4.HorizontalContentAlignment := HorizontalAlignment.Center;
  
  var minuteTextBox := new TextBox;
  DockP2.Children.Add(minuteTextBox);
  minuteTextBox.FontSize := 20;
  minuteTextBox.Width := 50;
  minuteTextBox.HorizontalContentAlignment := HorizontalAlignment.Center;
  minuteTextBox.MaxLength := 2;
  
  SP.Children.Add(DockP2);
  
  var EmptySpace3 := new System.Windows.Controls.Label;
  SP.Children.Add(EmptySpace3);
  EmptySpace3.Content := '';
  EmptySpace3.FontSize := 20;
  
  var addButton := new Button;
  SP.Children.Add(addButton);
  addbutton.HorizontalAlignment := HorizontalAlignment.Left;
  addbutton.Width := 200;
  addbutton.Height := 70;
  addButton.Content := 'Подтвердить';
  addButton.Click += (o, e) -> 
    begin
      if (DP.SelectedDate <> nil) and (TB.Text <> '') and (hourTextBox.Text <> '') and (minuteTextBox.Text <> '') then
        begin
          var hour := Convert.ToInt32(hourTextBox.Text);
          var minute := Convert.ToInt32(minuteTextBox.Text);
          if (hour >= 0) and (hour <= 23) and (minute >= 0) and (minute <= 59) then
            begin
              var selectedDateTime := new DateTime(DP.SelectedDate.Value.Year, DP.SelectedDate.Value.Month, DP.SelectedDate.Value.Day, hour, minute, 0);
              Diary.Add(Entry.Create(selectedDateTime, TB.Text, False));
              Diary.Sort(CompareEntriesByTime);
              SP.Children.Clear();
            end
          else
            MessageBox.Show('Время введено неверно', 'Ошибка!');
        end
      else 
        MessageBox.Show('Дата введена неверно', 'Ошибка!');
    end;
  result := SP;
end;

{$endregion Add} 

{$region Print}

function PrintEntries(Diary: List<Entry>): DataGrid;
begin
  var dataGrid := new DataGrid;
  dataGrid.AutoGenerateColumns := False;
  
  var dateColumn := new DataGridTextColumn;
  dateColumn.Header := 'Дата';
  dateColumn.Binding := new System.Windows.Data.Binding('DateAndTime');
  dateColumn.Binding.StringFormat := 'dd.MM.yyyy';
  dataGrid.Columns.Add(dateColumn);
  
  var timeColumn := new DataGridTextColumn;
  timeColumn.Header := 'Время';
  timeColumn.Binding := new System.Windows.Data.Binding('DateAndTime');
  timeColumn.Binding.StringFormat := 'HH:mm';
  dataGrid.Columns.Add(timeColumn);
  
  var descriptionColumn := new DataGridTextColumn;
  descriptionColumn.Header := 'Описание события';
  descriptionColumn.Binding := new System.Windows.Data.Binding('Task');
  dataGrid.Columns.Add(descriptionColumn);
  
  var statusColumn := new DataGridTextColumn;
  statusColumn.Header := 'Статус';
  statusColumn.Binding := new System.Windows.Data.Binding('Done');
  statusColumn.Binding.StringFormat := '{}{0:Выполнено;Не выполнено}';
  dataGrid.Columns.Add(statusColumn);
  
  result := dataGrid;
end;

{$endregion Print}

{$region Menu}

Procedure MainMenu(Diary: List<Entry>);
begin
  var win := new window;
  win.MinHeight := 400;
  win.MinWidth := 800;
  win.Name:='Diary';
  
  var Okn := new DockPanel;
  Dockpanel.SetDock(Okn,Dock.Left);
  
  var SV := new ScrollViewer;
  SV.VerticalScrollBarVisibility := scrollbarvisibility.Auto;
  SV.HorizontalScrollBarVisibility := scrollbarvisibility.Auto;
  
  var Butcont := new StackPanel;
  
  var EmptySpace := new System.Windows.Controls.Label;
  EmptySpace.Content := '  ';
  EmptySpace.FontSize := 20;
 
  var CC := new ContentControl; 
  
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
  add_button('Показать  событие', ()-> PrintEntries(Diary));
  //add_button('Редактировать событие', ()->  );
  //add_button('Очистить ежедневник', ()->  );
  //add_button('Выход', () -> );
  
  SV.Content := Butcont;
  Okn.Children.Add(SV);
  Okn.Children.Add(EmptySpace);
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