insert into users values('colby', 'admin', 'a', '18-JUN-89');
insert into persons values('colby', 'Colby', 'Warkentin', 'somewhere', 'me@mac.com', '780000001');

insert into users values('pat', 'patpass', 'p', '01-JAN-12');
insert into persons values('pat', 'Pat', '', 'somewhere', 'me@mac.com', '780000001');

insert into users values('doc', 'docpass', 'd', '02-FEB-12');
insert into persons values('doc', 'Doc', '', 'somewhere', 'me@mac.com', '780000001');

insert into users values('rad', 'radpass', 'r', '03-MAR-12');
insert into persons values('rad', 'Rad', '', 'somewhere', 'me@mac.com', '780000001');

insert into family_doctor values('doc','pat');
commit;