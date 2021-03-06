function [alpha, status] = quadr_svm(P, b, param)
%% Auxilary function to compute the quadratic programming of extensive SVM
% Input:   
%        P: n x n positive semidefinite matrix 
%        b: n x 1 linear term
% Output: 
%       alpha: n x 1 dual variables
% 
%
 n = size(P,1);
 [U,S] = eig(P);
 if ~isreal(diag(S))
     error('Error: P must be symmetric');
 elseif sum(find(diag(S) < 0))>0
     error('Error: P must be positive semidefinite matrix');
 end

sigma2 = param.sigma2;
eones = ones(n,1);

 cvx_begin sdp
   %cvx_precision high
   variable alpha(n) nonnegative;
   minimize(-(eones- b)'*alpha + 0.5*sigma2*alpha'*(U*S*U')*alpha )
     subject to
       alpha <= 1;
  cvx_end 
  
  status = cvx_status;