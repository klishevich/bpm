# BPM on Rails - Система управление бизнес-процессами

## Назначение системы

Система - является платформой для автоматизации бизнес-процессов предприятия. На базе BPM on Rails можно быстро автоматизировать бизнес процессы (процессы согласования, управление взаимоотношения с клиентами, автоматизация документооборота и т.п.).
Пример процесса для автоматизации - [ReqReassign_state.png](https://raw.githubusercontent.com/klishevich/bpm/master/ReqReassign_state.png)

## Загрузка оргструктуры предприятия

Для загрузки оргструктуры необходимо подготовить csv-файл следующего вида - [OgrStructureImport.csv](https://raw.githubusercontent.com/klishevich/bpm/master/db/import/OgrStructureImport.csv). После этого необходимо выполнить следующий код из seeds.rb:
```ruby
CSV.foreach("db/import/OgrStructureImport.csv", { encoding: "UTF-8", headers: true, 
	header_converters: :symbol, converters: :all, :col_sep => ";" }) do |row|
  Unit.create(row.to_hash) if !row.field(1).blank?
end
```

