% solve(最大勤務人数(リスト), 勤務可能日(リストのリスト), シフト(リストのリスト))
% solve(MaxWorkers, CanWork, Shift)
solve(_, [], _, []).
solve(MaxWorkers, [CanWorkEmployee | CanWork], MaxDays, [ShiftEmployee | Shift]) :-
    search_employee_shift(MaxWorkers, After, CanWorkEmployee, ShiftEmployee),
    le_max_days(ShiftEmployee, ShiftEmployee, MaxDays, MaxDays, 7),
    solve(After, CanWork, MaxDays, Shift).

% 従業員一人分の探索
% search_employee_shift(最大勤務人数のリスト，更新後の最大勤務人数のリスト，勤務可能日，シフト)
search_employee_shift([], [], [], []).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersBeforeToday | MaxWorkersAfter], [0 | CanWork], [0 | Shift]) :- !,
    % その曜日に従業員が働けない場合
    search_employee_shift(MaxWorkersBefore, MaxWorkersAfter, CanWork, Shift).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersAfterToday | MaxWorkersAfter], [1 | CanWork], [1 | Shift]) :-
    % その曜日に従業員が働けて，働く場合
    MaxWorkersBeforeToday > 0,
    MaxWorkersAfterToday is MaxWorkersBeforeToday - 1,
    search_employee_shift(MaxWorkersBefore, MaxWorkersAfter, CanWork, Shift).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersBeforeToday | MaxWorkersAfter], [1 | CanWork], [0 | Shift]) :-
    % その曜日に従業員が働けるが，働かない場合
    MaxWorkersBeforeToday > 0,
    search_employee_shift(MaxWorkersBefore, MaxWorkersAfter, CanWork, Shift).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersBeforeToday | MaxWorkersAfter], [_ | CanWork], [0 | Shift]) :-
    % シフトが埋まっている場合は働かない
    MaxWorkersBeforeToday =< 0,
    search_employee_shift(MaxWorkersBefore, MaxWorkersAfter, CanWork, Shift).

% シフトが最大連勤日数以下かどうかを調べる
% le_max_days(1週間のシフト, 調べている途中のシフト, 最大連勤可能日数, 最大連勤日数を調べるための変数, ループ回数)
le_max_days(_, _, _, _, 0) :- !. % 最後まで失敗しなければ成功
le_max_days(_, [1 | _], _, MaxDays, Loop) :-
    % 最大日数以上の1が並んでいる場合は失敗
    Loop > 0,
    MaxDays2 is MaxDays - 1,
    MaxDays2 < 0, !,
    fail.
le_max_days(WeeklyShift, [1 | Shift], OriginalMaxDays, MaxDays, Loop) :-
    % 最大日数以下で1を見つけた場合は次の日を見る
    Loop > 0,
    MaxDays2 is MaxDays - 1,
    MaxDays2 >= 0, !,
    le_max_days(WeeklyShift, Shift, OriginalMaxDays, MaxDays2, Loop).
le_max_days(WeeklyShift, [0 | _], OriginalMaxDays, _, Loop) :- !,
    % 0を見つけたらシフトの順番を入れ替えて最大日数以下かどうかを調べる
    Loop > 0,
    Loop2 is Loop - 1,
    bring_head_to_last(WeeklyShift, ChangedShift),
    le_max_days(ChangedShift, ChangedShift, OriginalMaxDays, OriginalMaxDays, Loop2).

% リストの先頭要素を最後尾に持ってくる
bring_head_to_last([Head | Tail], NewList) :-
    append(Tail, [Head], NewList).
