1)
select * from course
where credits>3;

select * from classroom
where building in ('Watson','Packard');

select * from course
where dept_name='Comp. Sci.';

select * from section
where semester='Fall';

select * from student
where tot_cred between 45 and 90;

select * from student
where substr(name,length(name)) in ('a','o','i','u','e','y','w');

select * from course
where course_id in(select course_id from prereq
    where prereq_id='CS-101');
2)
select dept_name, avg(salary) as avg_sal
from instructor
group by dept_name
order by avg_sal asc;

select building from section
group by building
order by count(course_id) desc
limit 1;

select dept_name,count(course_id) as count from course
group by dept_name
having count(course_id)=(select min(numbers.count) from (select count(course_id) as count from course
group by dept_name) as numbers);

select distinct id, name from student
where id in (select id from takes
where takes.course_id in (select course_id from course where dept_name='Comp. Sci.')
group by id
having count(course_id)>3);

select * from instructor
where dept_name in ('Biology', 'Philosophy', 'Music');

select distinct instructor.id, instructor.name,instructor.dept_name, instructor.salary from instructor, teaches
where instructor.id=teaches.id and year='2018' and teaches.id not in (select instructor.id from instructor, teaches
                                                                      where instructor.id=teaches.id and year='2017');

3)
select distinct student.id, name, dept_name, tot_cred from takes,student
where substr(course_id,1,2)='CS' and grade in ('A', 'A-') and takes.id=student.id
order by name asc;

select * from instructor
where instructor.id in(select i_id from advisor
                        where s_id in (select id from takes
                                        where grade not in ('A','A-','B+','B','B-') or grade is NULL));

select distinct * from department
where dept_name not in(select department.dept_name from student,takes,department
where student.id=takes.id and department.dept_name=student.dept_name and grade in ('F', 'C'));

select * from instructor
where id not in(select instructor.id from takes,teaches
    where teaches.id=instructor.id and teaches.course_id=takes.course_id and grade='A');

select * from course
where course_id in(select section.course_id from section, time_slot
    where section.time_slot_id=time_slot.time_slot_id and section.course_id=course.course_id and end_hr<=13);
