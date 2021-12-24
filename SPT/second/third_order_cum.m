%This is the function I use specifically to estimate the cumulants.
function cmat = third_order_cum (y,nlag,nsamp, overlap,flag, nfft, wind)
 
    [ly, nrecs] = size (y); 
    if (ly == 1) y=y(:);   ly = nrecs; nrecs = 1;      end 
    if (exist('overlap') ~= 1)   overlap = 0;          end 
    overlap = min(99, max(overlap,0)); 
    if (nrecs > 1)               overlap = 0;          end 
    if (exist('nsamp') ~= 1)     nsamp   = ly;         end
    if (nsamp > ly | nsamp <= 0) nsamp   = ly;         end
    if (exist('flag') ~= 1)      flag    = 'biased';   end 
    if (flag(1:1) ~= 'b')        flag    = 'unbiased'; end 
    if (exist('nfft') ~= 1)      nfft    = 128;        end
    if (nfft <= 0)               nfft    = 128;        end 
    if (exist('wind') ~= 1)      wind    = 0;          end

    nlag = min(nlag, nsamp-1); 
    if (nfft  < 2*nlag+1)   nfft = 2^nextpow2(nsamp); end 

% ---------------- create the lag window --------------------
    Bspec = zeros(nfft,nfft) ; 

    if (wind == 0) 
         indx = (1:nlag)';
         window = [1; sin(pi*indx/nlag) ./ (pi*indx/nlag)];
     else
         window = ones(nlag+1,1); 
     end 
     window = [window; zeros(nlag,1)];

% ---------------- cumulants in non-redundant region -----------------
% define cum(i,j) = E conj(x(n)) x(n+i) x(n+j) 
% for a complex process, we only have cum(i,j) = cum(j,i)
%

     overlap  = fix(nsamp * overlap / 100); 
     nadvance = nsamp - overlap; 
     nrecord  = fix ( (ly*nrecs - overlap) / nadvance ); 

     c3 = zeros(nlag+1,nlag+1);
     ind = [1:nsamp]';
     for k=1:nrecord,
         x = y(ind); x = x - mean(x);
         ind = ind + nadvance; 
         for j=0:nlag
             z = x(1:nsamp-j) .* x(j+1:nsamp); 
             for i=j:nlag
                 sum = z(1:nsamp-i)' * x(i+1:nsamp); 
                 if (flag(1:1) == 'b'), sum = sum/nsamp; 
                 else, sum = sum / (nsamp-i); 
                 end 
                 c3(i+1,j+1) = c3(i+1,j+1) + sum; 
             end
         end
     end
     c3 = c3 / nrecord; 

% cumulants elsewhere by symmetry  ------------------------------------------
     c3 = c3 + tril(c3,-1)';           % complete I quadrant 
     c31 = c3(2:nlag+1,2:nlag+1); 
     c32 = zeros(nlag,nlag);  c33 = c32;  c34 = c32; 
     for i=1:nlag, 
         x = c31(i:nlag,i); 
         c32(nlag+1-i,1:nlag+1-i) = x'; 
         c34(1:nlag+1-i,nlag+1-i) = x; 
         if (i < nlag) 
           x = flipud(x(2:length(x))); 
           c33 = c33 + diag(x,i) + diag(x,-i); 
         end 
     end 

     c33  = c33 + diag(c3(1,nlag+1:-1:2)); 
     cmat = [ [c33, c32, zeros(nlag,1)]; [ [c34; zeros(1,nlag)] , c3 ] ]; 
 end