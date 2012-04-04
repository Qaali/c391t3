insert into users values('colby', 'admin', 'a', '18-JUN-89');
insert into persons values('colby', 'Colby', 'Warkentin', 'somewhere', 'me1@mac.com', '780000001');

insert into users values('pat', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat', 'Pat', ' ', 'somewhere', 'me2@mac.com', '780000001');

insert into users values('doc', 'docpass', 'd', '02-FEB-12');
insert into persons values('doc', 'Doc', ' ', 'somewhere', 'me3@mac.com', '780000001');

insert into users values('rad', 'radpass', 'r', '03-MAR-12');
insert into persons values('rad', 'Rad', ' ', 'somewhere', 'me4@mac.com', '780000001');

insert into users values('doc2', 'docpass', 'd', '02-FEB-12');
insert into persons values('doc2', 'Doc2', ' ', 'somewhere', 'me5@mac.com', '780000001');

insert into users values('pat2', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat2', 'pat2', ' ', 'somewhere', 'me6@mac.com', '780000001');

insert into users values('pat3', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat3', 'pat3', ' ', 'somewhere', 'me7@mac.com', '780000001');

insert into family_doctor values('doc','pat');
insert into family_doctor values('doc2','pat');
insert into family_doctor values('doc','pat2');
insert into family_doctor values('doc2','pat2');

drop sequence record_seq;
create sequence record_seq;
insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'rad', 'blah', '18-JUN-89', '18-JUN-89', 'bad', 'dead');
drop sequence pic_seq_1;
create sequence pic_seq_1;

commit;
