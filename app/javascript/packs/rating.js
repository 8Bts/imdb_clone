const rating = (() => {
  const token = document.getElementsByName(
    "csrf-token"
  )[0].content;
  const FULL_STAR = '<i class="fas fa-star fa-lg full-star"></i>';
  const HALLOW_STAR = '<i class="far fa-star fa-lg user-star"></i>';

  const paintStars = (starBtns, offset, indicator) => {
    starBtns.forEach((btn, idx) => {
      if (idx >= offset) {
        btn.innerHTML = HALLOW_STAR;
      } else {
        btn.innerHTML = FULL_STAR;
      }

      if (offset === 0) {
        indicator.innerText = indicator.initialRating;
      } else {
        indicator.innerText = offset;
      }
    });
  };

  const handlePostClick = async (m_id, rating) => {
    const data = {};
    data.movie_id = m_id;
    data.rating = rating;
    const response = await fetch('/votes', {
      method: 'POST',
      redirect: 'follow',
      body: JSON.stringify(data),
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json',
      },
    });
    if (response.redirected) {
      window.location.href = response.url;
      return Promise.reject(response.status);
    }
    const rData = await response.json();
    rData.ok = response.ok;

    return rData;
  };

  const handlePutClick = async (v_id, m_id, rating) => {
    const data = {};
    data.movie_id = m_id;
    data.rating = rating;
    const response = await fetch(`/votes/${v_id}`, {
      method: 'PUT',
      redirect: 'follow',
      body: JSON.stringify(data),
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json',
      },
    });
    if (response.redirected) {
      window.location.href = response.url;
    }

    return response;
  };

  const handleDeleteClick = async (v_id) => {
    const response = await fetch(`/votes/${v_id}`, {
      method: 'DELETE',
      redirect: 'follow',
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json',
      },
    });
    if (response.redirected) {
      window.location.href = response.url;
    }

    return response;
  };

  const setRateBoxListeners = () => {
    const boxOpenBtns = Array.from(document.querySelectorAll('.btn-open-rate-box'));
    let lastRating = -1;


    boxOpenBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        const row = btn.getAttribute('data-row-id');
        let isRated = btn.getAttribute('data-is-rated') === 'true';
        const rateBox = document.querySelector(`div[data-row-id="${row}"]`);
        const rateIndicator = document.querySelector(`span[data-row-id="${row}"]`);
        let voteId = rateIndicator.getAttribute('data-vote-id');
        const rBoxRight = rateBox.getElementsByClassName('rb-right')[0];
        const rateBtns = Array.from(rateBox.getElementsByClassName('btn-rate'));
        const unrateBtns = Array.from(rateBox.getElementsByClassName('btn-unrate'));

        rateIndicator.initialRating = rateIndicator.innerText;
        btn.innerHTML = FULL_STAR;
        rateBox.classList.remove('d-none');

        rateBox.onmouseleave = () => {
          paintStars(rateBtns, 0, rateIndicator)
          rateBox.classList.add('d-none');
          if (!isRated) btn.innerHTML = HALLOW_STAR;
        };

        rBoxRight.onmouseleave = () => { 
          paintStars(rateBtns, 0, rateIndicator);
          lastRating = -1;
        };

        rateBtns.forEach((rBtn) => {
          rBtn.onclick = () => {
            if (isRated) {
              // Make put request to update a vote
              handlePutClick(voteId, row, rBtn.getAttribute('data-rating')).then((response) => {
                if (response.ok) {
                  rateIndicator.initialRating = rBtn.getAttribute('data-rating');
                  paintStars(rateBtns, 0, rateIndicator);
                  lastRating = -1;
                  rateBox.classList.add('d-none');
                }
              });
            } else {
              // Make post request to create new vote
              handlePostClick(row, rBtn.getAttribute('data-rating')).then((response) => {
                if (response.ok) {
                  rateIndicator.initialRating = rBtn.getAttribute('data-rating');
                  rateIndicator.setAttribute('data-vote-id', response.id);
                  btn.setAttribute('data-is-rated', 'true');
                  isRated = true;
                  paintStars(rateBtns, 0, rateIndicator);

                  lastRating = -1;
                  rateBox.classList.add('d-none');
                }
              }).catch(() => '' );
            }
          };

          rBtn.onmouseenter = () => {
            const btnRating = rBtn.getAttribute('data-rating');

            if (btnRating === lastRating) return;
            lastRating = btnRating;
            paintStars(rateBtns, btnRating, rateIndicator);
          };
        });

        unrateBtns.forEach((uBtn) => {
          uBtn.onclick = () => {
            if (isRated) {
              handleDeleteClick(voteId).then((response) => {
                if (response.ok) {
                  rateIndicator.initialRating = '';
                  btn.setAttribute('data-is-rated', 'false');
                  isRated = false;
                  paintStars(rateBtns, 0, rateIndicator);
                  lastRating = -1;
                  rateBox.classList.add('d-none');
                }
              });
            } else {
              rateIndicator.initialRating = '';
              paintStars(rateBtns, 0, rateIndicator);
              lastRating = -1;
              rateBox.classList.add('d-none');
            }      
          };
        });
      });
    });
  };


  return { setRateBoxListeners };
})();

export default rating;