# BPM on Rails - Business Process Management System

## Purpose of the System

BPM on Rails is Framework for business process automatisation. Built on top of Ruby on Rails it leverages all power of Ruby on Rails and make it super easy to set up business processes with necessary states, actors and data.

Example of business process for automatisation described here - [ReqReassign_state.png](https://raw.githubusercontent.com/klishevich/bpm/master/ReqReassign_state.png)

## Functionality realized

* *Multiprocess* - you could add several processes and all they will be displayed in one list - assignments list
* *Parallel assignments* - on each state task could be assigned to several users
* *Dashboard* - home screen contain dashboard where all most important information is displayed as: new tasks, tasks with deadline, graphs, news feed
* *Nested forms* - forms which contain nested data, for example, purchase list
* *Notifications* - sending notifications for tasks being assigned and tasks being closed
* *Organisation structure* - dictionary to store employees and there hierarchy, which is used to define assignee for tasks
* *Roles* - each user could be assigned for several roles, and according to the roles user have, logic of assignment could be realised
* *Admin interface* - user with admin role could do some actions (assign roles to users)
* *History of change* - history of process is stored and contain following information: user, date of change, state, description
* *Reports* - allow you to make you own business specific reports, for now SLA Report is made.
* *Mobile Adaptive* - mobile adaptive theme is used, so usage from mobile devices is very comfortable.
* *Work with Files* - files could be attached, deleted, and downloaded
* *Tests* - RSpec integration test are made for 2 processes

**All described functionality has reference implementation** in following classes: ReqPurchase, ReqReassign, ReqRolepurchase, ReqWorkgroup

Module ReqMain contains base functionality for process routing.

## Naming conventions

All classes which describe process should name Req… (ReqPurchase for ex.)
All classes which contain additional data for some process should name Inf  + Process name + Data name (InfWorkgroupMember for ReqWorkgroup)

## Future

I am developing BPM on Rails, and going to continue its development

## Cooperation

I am opened for cooperation in BPM on Rails development, just email me info@busation.com or tweet me @busation

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

## Загрузка пользователей

Производится аналогично загрузке оргструктуры, формат файла для загрузки - [UsersImport.csv](https://raw.githubusercontent.com/klishevich/bpm/master/db/import/UsersImport.csv).

