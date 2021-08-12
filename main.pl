% solve(最大勤務人数(リスト), 勤務可能日(リストのリスト), シフト(リストのリスト))
% solve(MaxWorkers, CanWork, Shift)
solve(_, [], []).
solve(MaxWorkers, [CanWorkEmployee | CanWork], [ShiftEmployee | Shift]) :-
    search_employee_shift(MaxWorkers, After, CanWorkEmployee, ShiftEmployee),
    solve(After, CanWork, Shift).

% 従業員一人分の探索
% search_employee_shift(最大勤務人数のリスト，更新後の最大勤務人数のリスト，勤務可能日，シフト)
search_employee_shift([], [], [], []).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersBeforeToday | MaxWorkersAfter], [0 | CanWork], [0 | Shift]) :- !,
    % その曜日に従業員が働けない場合
    search_employee_shift(MaxWorkersBefore, MaxWorkersAfter, CanWork, Shift).
search_employee_shift([MaxWorkersBeforeToday | MaxWorkersBefore], [MaxWorkersAfterToday | MaxWorkersAfter], [1 | CanWork], [1 | Shift]) :-
    % その曜日に従業員が働けて，まだシフトが埋まっていない場合
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
