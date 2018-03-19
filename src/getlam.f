C Output from Public domain Ratfor, version 1.0
      subroutine getlam(n,p,x,sx,lambda,order,dist,ns,s,strech,vecx,temp
     *sx)
      integer n,p,ns,order(n)
      double precision x(n,p),sx(n,p),s(ns,p),lambda(n),dist(n),tempsx(p
     *), vecx(p),strech
      if(strech .lt. 0d0)then
      strech=0d0
      endif
      if(strech .gt. 2d0)then
      strech=2d0
      endif
      do23004 j=1,p
      s(1,j)=s(1,j)+strech*(s(1,j)-s(2,j))
      s(ns,j)=s(ns,j)+strech*(s(ns,j)-s(ns-1,j))
23004 continue
23005 continue
      do23006 i=1,n
      do23008 j=1,p 
      vecx(j)=x(i,j)
23008 continue
23009 continue
      call lamix(ns,p,vecx,s,lambda(i),dist(i),tempsx)
      do23010 j=1,p 
      sx(i,j)=tempsx(j)
23010 continue
23011 continue
23006 continue
23007 continue
      do23012 i=1,n
      order(i)=i
23012 continue
23013 continue
      call sortdi(lambda,order,1,n)
      call newlam(n,p,sx,lambda,order)
      return
      end
      subroutine newlam(n,p,sx,lambda,tag)
      integer n,p,tag(n)
      double precision sx(n,p),lambda(n),lami
      lambda(tag(1))=0d0
      i=1
23014 if(.not.(i.lt.n))goto 23016
      lami=0d0
      do23017 j=1,p
      lami=lami+(sx(tag(i+1),j)-sx(tag(i),j))**2
23017 continue
23018 continue
      lambda(tag(i+1))=lambda(tag(i))+dsqrt(lami)
23015 i=i+1
      goto 23014
23016 continue
      return
      end
      subroutine lamix(ns,p,x,s,lambda,dismin,temps)
      integer ns,p
      double precision lambda,x(p),s(ns,p),dismin,temps(p)
      double precision v(2,p),d1sqr,d2sqr,d12,dsqr, d1,w
      real lam,lammin
      integer left,right
      dismin=1d60
      lammin=1
      ik = 1
23019 if(.not.(ik.lt.ns))goto 23021
      d1sqr=0.0
      d2sqr=0.0
      do23022 j=1,p
      v(2,j)=x(j)-s(ik,j)
      v(1,j)=s(ik+1,j)-s(ik,j)
      d1sqr=d1sqr+v(1,j)**2
      d2sqr=d2sqr+v(2,j)**2
23022 continue
23023 continue
      if(d1sqr.lt.1d-8*d2sqr)then
      lam=ik
      dsqr=d2sqr
      else
      d12=0d0
      do23026 j=1,p
      d12 = d12+v(1,j)*v(2,j)
23026 continue
23027 continue
      d1=d12/d1sqr
      if(d1.gt.1d0)then
      lam=ik+1
      dsqr=d1sqr+d2sqr-2d0*d12
      else
      if(d1.lt.0.0)then
      lam=ik
      dsqr=d2sqr
      else
      lam=ik+(d1)
      dsqr=d2sqr-(d12**2)/d1sqr
      endif
      endif
      endif
      if(dsqr.lt.dismin)then
      dismin=dsqr
      lammin=lam
      endif
23020 ik=ik+1
      goto 23019
23021 continue
      left=lammin
      if(lammin.ge.ns)then
      left=ns-1
      endif
      right=left+1
      w=dble(lammin-left)
      do23036 j=1,p
      temps(j)=(1d0-w)*s(left,j)+w*s(right,j)
23036 continue
23037 continue
      lambda=dble(lammin)
      return
      end
