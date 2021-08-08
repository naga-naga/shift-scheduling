% solve(最大勤務人数(リスト), 勤務可能日(リストのリスト), 最大連勤日数(定数), シフト(リストのリスト))
% solve(MaxWorkers, CanWork, MaxConsecutiveWork, Shift)
solve(_, [], _, []).
solve(MaxWorkers, [CanWorkEmployee | CanWork], MaxConsecutiveWork, [ShiftEmployee | Shift]) :-
    employee(MaxWorkers, After, CanWorkEmployee, MaxConsecutiveWork, ShiftEmployee),
    solve(After, CanWork, MaxConsecutiveWork, Shift).

% 従業員一人分の探索
employee([], [], [], _, []).
% その曜日に従業員が働けない場合
employee([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveWork, [ShiftToday | Shift]) :-
    employee(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveWork, Shift),
    CanWorkToday = 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.
% その曜日に従業員が働けて，まだシフトが埋まっていない場合
employee([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveWork, [ShiftToday | Shift]) :-
    employee(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveWork, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday > 0,
    ShiftToday = 1,
    MaxWokersAfterToday is MaxWokersBeforeToday - 1.
% その曜日に従業員が働けるが，シフトが埋まっている場合
employee([MaxWokersBeforeToday | MaxWokersBefore], [MaxWokersAfterToday | MaxWokersAfter], [CanWorkToday | CanWork], MaxConsecutiveWork, [ShiftToday | Shift]) :-
    employee(MaxWokersBefore, MaxWokersAfter, CanWork, MaxConsecutiveWork, Shift),
    CanWorkToday = 1,
    MaxWokersBeforeToday =< 0,
    ShiftToday = 0,
    MaxWokersAfterToday = MaxWokersBeforeToday.
