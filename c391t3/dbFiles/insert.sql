insert into users values('colby', 'admin', 'a', '18-JUN-1989');
insert into persons values('colby', 'Colby', 'Warkentin', 'somewhere', 'me1@mac.com', '780000001');

insert into users values('pat', 'patpass', 'p', '01-JAN-2012');
insert into persons values('pat', 'Pat', 'Paterson', 'somewhere', 'me2@mac.com', '780000001');

insert into users values('susy', 'patpass', 'p', '01-JAN-2012');
insert into persons values('susy', 'Susy', 'Buhler', 'somewhere', 'me3@mac.com', '780000001');

insert into users values('bill', 'patpass', 'p', '01-JAN-2012');
insert into persons values('bill', 'Bill', 'Simpson', 'somewhere', 'me4@mac.com', '780000001');

insert into users values('doc', 'docpass', 'd', '02-FEB-2012');
insert into persons values('doc', 'Doc', 'Dockers', 'somewhere', 'me5@mac.com', '780000001');

insert into users values('rick', 'docpass', 'd', '02-FEB-2012');
insert into persons values('rick', 'Richard', 'Pain', 'somewhere', 'me6@mac.com', '780000001');

insert into users values('rad', 'radpass', 'r', '03-MAR-2012');
insert into persons values('rad', 'Rad', 'Raderson', 'somewhere', 'me7@mac.com', '780000001');

insert into users values('verne', 'radpass', 'r', '07-MAR-2012');
insert into persons values('verne', 'Verne', 'Radiate', 'somewhere', 'me8@mac.com', '780000001');

insert into family_doctor values('doc','pat');
insert into family_doctor values('rick','pat');
insert into family_doctor values('doc','bill');
insert into family_doctor values('rick','susy');


insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'rad', 'X-ray', '18-JUN-1989', '18-JUN-1989', 'Breast Cancer', 'X-ray found breast cancer');
drop sequence pic_seq_1;
create sequence pic_seq_1;

insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'rad', 'MRI', '18-JUN-2011', '18-JUN-2011', 'Okay', 'MRI confirmed nothing in his heart');
drop sequence pic_seq_2;
create sequence pic_seq_2;

insert into radiology_record values (record_seq.nextval, 'bill', 'doc', 'rad', 'CAT', '18-DEC-2011', '18-DEC-2011', 'Throat Cancer', 'Cat-scan found throat cancer');
drop sequence pic_seq_3;
create sequence pic_seq_3;

insert into radiology_record values (record_seq.nextval, 'bill', 'rick', 'rad', 'physical', '18-JUN-2009', '18-JUN-2009', 'Breast Cancer', 'physical found breast cancer');
drop sequence pic_seq_4;
create sequence pic_seq_4;

insert into radiology_record values (record_seq.nextval, 'susy', 'rick', 'rad', 'MRI', '18-JUN-2010', '18-JUN-2010', 'Heart Attack', 'dead');
drop sequence pic_seq_5;
create sequence pic_seq_5;

insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'verne', 'MRI', '18-JUL-2011', '18-JUN-1989', 'Breast Cancer', 'x-ray inconclusive, MRI did confirm doctors opinion');
drop sequence pic_seq_6;
create sequence pic_seq_6;

insert into radiology_record values (record_seq.nextval, 'pat', 'doc', 'verne', 'MRI', '18-AUG-2011', '18-JUN-2011', 'Okay', 'MRI confirmed nothing in his heart, but she has breast cancer');
drop sequence pic_seq_7;
create sequence pic_seq_7;

insert into radiology_record values (record_seq.nextval, 'bill', 'rick', 'verne', 'CAT', '19-AUG-2011', '20-AUG-2011', 'Throat Cancer', 'Cat-scan found throat cancer, MRI did not');
drop sequence pic_seq_8;
create sequence pic_seq_8;

insert into radiology_record values (record_seq.nextval, 'bill', 'rick', 'verne', 'MRI', '21-AUG-2011', '21-AUG-2011', 'Breast Cancer', 'Bill back again, has male breast cancer');
drop sequence pic_seq_9;
create sequence pic_seq_9;

insert into radiology_record values (record_seq.nextval, 'susy', 'rick', 'verne', 'MRI', '01-DEC-2011', '01-DEC-2011', 'Heart Attack', 'dead, not sure why we still examine her');
drop sequence pic_seq_10;
create sequence pic_seq_10;

commit;
