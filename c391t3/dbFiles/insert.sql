insert into users values('colby', 'admin', 'a', '18-JUN-89');
insert into persons values('colby', 'Colby', 'Warkentin', 'somewhere', 'me1@mac.com', '780000001');

insert into users values('pat', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat', 'Pat', ' ', 'somewhere', 'me2@mac.com', '780000001');

insert into users values('pat2', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat2', 'pat2', ' ', 'somewhere', 'me3@mac.com', '780000001');

insert into users values('pat3', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat3', 'pat3', ' ', 'somewhere', 'me4@mac.com', '780000001');

insert into users values('doc', 'docpass', 'd', '02-FEB-12');
insert into persons values('doc', 'Doc', ' ', 'somewhere', 'me5@mac.com', '780000001');

insert into users values('doc2', 'docpass', 'd', '02-FEB-12');
insert into persons values('doc2', 'Doc2', ' ', 'somewhere', 'me6@mac.com', '780000001');

insert into users values('rad', 'radpass', 'r', '03-MAR-12');
insert into persons values('rad', 'Rad', ' ', 'somewhere', 'me7@mac.com', '780000001');

insert into users values('rad2', 'radpass', 'r', '07-MAR-12');
insert into persons values('rad2', 'Rad2', 'Raderson', 'somewhere', 'me8@mac.com', '780000001');

insert into family_doctor values('doc','pat');
insert into family_doctor values('doc2','pat');
insert into family_doctor values('doc','pat2');
insert into family_doctor values('doc2','pat2');

drop sequence record_seq;
create sequence record_seq;

insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'rad', 'X-ray', '18-JUN-89', '18-JUN-89', 'Breast Cancer', 'X-ray found breast cancer');
drop sequence pic_seq_1;
create sequence pic_seq_1;

insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'rad', 'MRI', '18-JUN-11', '18-JUN-11', 'Okay', 'MRI confirmed nothing in his heart');
drop sequence pic_seq_2;
create sequence pic_seq_2;

insert into radiology_record values (record_seq.nextval, 'pat2', 'doc', 'rad2', 'Cat-scan', '18-DEC-11', '18-DEC-11', 'Throat Cancer', 'Cat-scan found throat cancer');
drop sequence pic_seq_3;
create sequence pic_seq_3;

insert into radiology_record values (record_seq.nextval, 'pat2', 'doc2', 'rad2', 'physical', '18-JUN-09', '18-JUN-09', 'Breast Cancer', 'physical found breast cancer');
drop sequence pic_seq_4;
create sequence pic_seq_4;

insert into radiology_record values (record_seq.nextval, 'pat3', 'doc2', 'rad', 'MRI', '18-JUN-10', '18-JUN-10', 'Heart Attack', 'dead');
drop sequence pic_seq_5;
create sequence pic_seq_5;

commit;
